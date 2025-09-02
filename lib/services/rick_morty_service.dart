import 'dart:async';

import '../models/character.dart';

class RickMortyService {
  static const String baseUrl = 'https://rickandmortyapi.com/api';
  
  // StreamController para manejar el flujo de personajes
  final StreamController<List<Character>> _charactersController = 
      StreamController<List<Character>>.broadcast();
  
  // StreamController para manejar el estado de carga
  final StreamController<bool> _loadingController = 
      StreamController<bool>.broadcast();
  
  // StreamController para manejar errores
  final StreamController<String> _errorController = 
      StreamController<String>.broadcast();
  
  // StreamController para manejar el chat
  final StreamController<ChatMessage> _chatController = 
      StreamController<ChatMessage>.broadcast();
  
  // Getters para los streams
  Stream<List<Character>> get charactersStream => _charactersController.stream;
  Stream<bool> get loadingStream => _loadingController.stream;
  Stream<String> get errorStream => _errorController.stream;
  Stream<ChatMessage> get chatStream => _chatController.stream;
  
  // Lista de personajes principales predefinidos
  final List<String> mainCharacters = [
    'Rick Sanchez',
    'Morty Smith',
    'Summer Smith',
    'Beth Smith',
    'Jerry Smith',
    'Bird Person',
    'Mr. Meeseeks',
    'Evil Morty',
    'Mr. Poopybutthole',
    'Squanchy'
  ];
  
  // Método para obtener personajes por nombre
  Future<void> getCharactersByName(String name) async {
    try {
      _loadingController.add(true);
      _errorController.add('');
      
      // Simular delay de red
      await Future.delayed(Duration(milliseconds: 800));
      
      // Filtrar personajes por nombre
      final filteredChars = _getMockCharacters()
          .where((char) => char.name.toLowerCase().contains(name.toLowerCase()))
          .toList();
      
      if (filteredChars.isNotEmpty) {
        _charactersController.add(filteredChars);
      } else {
        _errorController.add('No se encontraron personajes con ese nombre');
        _charactersController.add([]);
      }
    } catch (e) {
      _errorController.add('Error al buscar personajes: $e');
      _charactersController.add([]);
    } finally {
      _loadingController.add(false);
    }
  }
  
  // Método para obtener todos los personajes principales
  Future<void> getMainCharacters() async {
    try {
      _loadingController.add(true);
      _errorController.add('');
      
      // Simular delay de red
      await Future.delayed(Duration(milliseconds: 600));
      
      // Obtener solo los personajes principales
      final mainChars = _getMockCharacters()
          .where((char) => mainCharacters.contains(char.name))
          .toList();
      
      _charactersController.add(mainChars);
    } catch (e) {
      _errorController.add('Error al obtener personajes principales');
      _charactersController.add([]);
    } finally {
      _loadingController.add(false);
    }
  }
  
  // Método para agregar mensajes al chat
  void addChatMessage(ChatMessage message) {
    _chatController.add(message);
  }
  
  // Método para obtener un personaje aleatorio
  Future<void> getRandomCharacters() async {
    try {
      _loadingController.add(true);
      _errorController.add('');
      
      // Simular delay de red
      await Future.delayed(Duration(milliseconds: 700));
      
      // Obtener un solo personaje aleatorio
      final allChars = _getMockCharacters();
      final randomIndex = DateTime.now().millisecondsSinceEpoch % allChars.length;
      final randomChar = allChars[randomIndex];
      _charactersController.add([randomChar]);
    } catch (e) {
      _errorController.add('Error al obtener personaje aleatorio');
      _charactersController.add([]);
    } finally {
      _loadingController.add(false);
    }
  }
  
  // Método privado para obtener personajes simulados
  List<Character> _getMockCharacters() {
    return [
      Character(
        id: 1,
        name: 'Rick Sanchez',
        status: 'Alive',
        species: 'Human',
        type: '',
        gender: 'Male',
        origin: Origin(name: 'Earth (C-137)', url: ''),
        location: Location(name: 'Citadel of Ricks', url: ''),
        image: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
        episode: ['S01E01', 'S01E02', 'S01E03'],
        url: '',
        created: '2017-11-04T18:48:46.250Z',
      ),
      Character(
        id: 2,
        name: 'Morty Smith',
        status: 'Alive',
        species: 'Human',
        type: '',
        gender: 'Male',
        origin: Origin(name: 'Earth (C-137)', url: ''),
        location: Location(name: 'Earth (C-137)', url: ''),
        image: 'https://rickandmortyapi.com/api/character/avatar/2.jpeg',
        episode: ['S01E01', 'S01E02', 'S01E03'],
        url: '',
        created: '2017-11-04T18:50:21.651Z',
      ),
      Character(
        id: 3,
        name: 'Summer Smith',
        status: 'Alive',
        species: 'Human',
        type: '',
        gender: 'Female',
        origin: Origin(name: 'Earth (C-137)', url: ''),
        location: Location(name: 'Earth (C-137)', url: ''),
        image: 'https://rickandmortyapi.com/api/character/avatar/3.jpeg',
        episode: ['S01E01', 'S01E02', 'S01E03'],
        url: '',
        created: '2017-11-04T18:52:31.756Z',
      ),
      Character(
        id: 4,
        name: 'Beth Smith',
        status: 'Alive',
        species: 'Human',
        type: '',
        gender: 'Female',
        origin: Origin(name: 'Earth (C-137)', url: ''),
        location: Location(name: 'Earth (C-137)', url: ''),
        image: 'https://rickandmortyapi.com/api/character/avatar/4.jpeg',
        episode: ['S01E01', 'S01E02', 'S01E03'],
        url: '',
        created: '2017-11-04T18:55:38.445Z',
      ),
      Character(
        id: 5,
        name: 'Jerry Smith',
        status: 'Alive',
        species: 'Human',
        type: '',
        gender: 'Male',
        origin: Origin(name: 'Earth (C-137)', url: ''),
        location: Location(name: 'Earth (C-137)', url: ''),
        image: 'https://rickandmortyapi.com/api/character/avatar/5.jpeg',
        episode: ['S01E01', 'S01E02', 'S01E03'],
        url: '',
        created: '2017-11-04T18:57:38.445Z',
      ),
      Character(
        id: 6,
        name: 'Bird Person',
        status: 'Dead',
        species: 'Bird-Person',
        type: '',
        gender: 'Male',
        origin: Origin(name: 'Bird World', url: ''),
        location: Location(name: 'St. Gloopy Noops Hospital', url: ''),
        image: 'https://rickandmortyapi.com/api/character/avatar/6.jpeg',
        episode: ['S01E01', 'S01E02', 'S01E03'],
        url: '',
        created: '2017-11-04T18:59:38.445Z',
      ),
      Character(
        id: 7,
        name: 'Mr. Meeseeks',
        status: 'unknown',
        species: 'Meeseeks',
        type: '',
        gender: 'Male',
        origin: Origin(name: 'Mr. Meeseeks Box', url: ''),
        location: Location(name: 'Earth (C-137)', url: ''),
        image: 'https://rickandmortyapi.com/api/character/avatar/7.jpeg',
        episode: ['S01E01', 'S01E02', 'S01E03'],
        url: '',
        created: '2017-11-04T19:01:38.445Z',
      ),
      Character(
        id: 8,
        name: 'Evil Morty',
        status: 'Alive',
        species: 'Human',
        type: '',
        gender: 'Male',
        origin: Origin(name: 'Unknown', url: ''),
        location: Location(name: 'Citadel of Ricks', url: ''),
        image: 'https://rickandmortyapi.com/api/character/avatar/8.jpeg',
        episode: ['S01E01', 'S01E02', 'S01E03'],
        url: '',
        created: '2017-11-04T19:03:38.445Z',
      ),
      Character(
        id: 9,
        name: 'Mr. Poopybutthole',
        status: 'Alive',
        species: 'Poopybutthole',
        type: '',
        gender: 'Male',
        origin: Origin(name: 'Unknown', url: ''),
        location: Location(name: 'Earth (C-137)', url: ''),
        image: 'https://rickandmortyapi.com/api/character/avatar/9.jpeg',
        episode: ['S01E01', 'S01E02', 'S01E03'],
        url: '',
        created: '2017-11-04T19:05:38.445Z',
      ),
      Character(
        id: 10,
        name: 'Squanchy',
        status: 'Dead',
        species: 'Cat-Person',
        type: '',
        gender: 'Male',
        origin: Origin(name: 'Planet Squanch', url: ''),
        location: Location(name: 'Planet Squanch', url: ''),
        image: 'https://rickandmortyapi.com/api/character/avatar/10.jpeg',
        episode: ['S01E01', 'S01E02', 'S01E03'],
        url: '',
        created: '2017-11-04T19:07:38.445Z',
      ),
    ];
  }
  
  // Método para limpiar todos los streams
  void dispose() {
    _charactersController.close();
    _loadingController.close();
    _errorController.close();
    _chatController.close();
  }
}

// Modelo para los mensajes del chat
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<Character>? characters;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.characters,
  });
}
