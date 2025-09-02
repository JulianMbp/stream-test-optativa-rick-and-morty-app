import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

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
      
      // Hacer petición real a la API
      final response = await http.get(
        Uri.parse('$baseUrl/character/?name=$name'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final apiResponse = ApiResponse.fromJson(data);
        _charactersController.add(apiResponse.results);
      } else {
        _errorController.add('No se encontraron personajes con ese nombre');
        _charactersController.add([]);
      }
    } catch (e) {
      _errorController.add('Error al conectar con la API: $e');
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
      
      // Hacer petición real a la API para obtener todos los personajes
      final response = await http.get(
        Uri.parse('$baseUrl/character'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final apiResponse = ApiResponse.fromJson(data);
        
        // Filtrar solo los personajes principales de la primera página
        final mainChars = apiResponse.results
            .where((char) => mainCharacters.contains(char.name))
            .toList();
        
        _charactersController.add(mainChars);
      } else {
        _errorController.add('Error al obtener personajes principales');
        _charactersController.add([]);
      }
    } catch (e) {
      _errorController.add('Error al conectar con la API: $e');
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
      
      // Generar un ID aleatorio entre 1 y 826 (total de personajes en la API)
      final randomId = (DateTime.now().millisecondsSinceEpoch % 826) + 1;
      
      // Hacer petición real a la API para obtener un personaje aleatorio
      final response = await http.get(
        Uri.parse('$baseUrl/character/$randomId'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final character = Character.fromJson(data);
        _charactersController.add([character]);
      } else {
        _errorController.add('Error al obtener personaje aleatorio');
        _charactersController.add([]);
      }
    } catch (e) {
      _errorController.add('Error al conectar con la API: $e');
      _charactersController.add([]);
    } finally {
      _loadingController.add(false);
    }
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
