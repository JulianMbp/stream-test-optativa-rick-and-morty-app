import 'dart:async';

import 'package:flutter/material.dart';

import '../components/character_card.dart';
import '../models/character.dart';
import '../services/rick_morty_service.dart';

class RickMortyChatScreen extends StatefulWidget {
  const RickMortyChatScreen({super.key});

  @override
  State<RickMortyChatScreen> createState() => _RickMortyChatScreenState();
}

class _RickMortyChatScreenState extends State<RickMortyChatScreen> {
  final RickMortyService _service = RickMortyService();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  String _errorMessage = '';

  // Stream subscriptions
  late StreamSubscription<List<Character>> _charactersSubscription;
  late StreamSubscription<bool> _loadingSubscription;
  late StreamSubscription<String> _errorSubscription;
  late StreamSubscription<ChatMessage> _chatSubscription;

  @override
  void initState() {
    super.initState();
    _initializeStreams();
    _addWelcomeMessage();
  }

  void _initializeStreams() {
    // Suscribirse al stream de personajes
    _charactersSubscription = _service.charactersStream.listen((characters) {
      // Agregar respuesta al chat si hay personajes
      if (characters.isNotEmpty) {
        // Determinar qué tipo de búsqueda fue
        String query = '';
        if (_messages.isNotEmpty && _messages.last.isUser) {
          query = _messages.last.text;
        }
        _addCharacterResponse(characters, query);
      }
    });

    // Suscribirse al stream de carga
    _loadingSubscription = _service.loadingStream.listen((loading) {
      setState(() {
        _isLoading = loading;
      });
    });

    // Suscribirse al stream de errores
    _errorSubscription = _service.errorStream.listen((error) {
      setState(() {
        _errorMessage = error;
      });
    });

    // Suscribirse al stream del chat
    _chatSubscription = _service.chatStream.listen((message) {
      setState(() {
        _messages.add(message);
      });
      _scrollToBottom();
    });
  }

  void _addWelcomeMessage() {
    final welcomeMessage = ChatMessage(
      text: '¡Hola! Soy tu asistente de Rick and Morty. ¿Qué te gustaría saber sobre los personajes?',
      isUser: false,
      timestamp: DateTime.now(),
    );
    _service.addChatMessage(welcomeMessage);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onCharacterButtonPressed(String characterName) {
    // Agregar mensaje del usuario
    final userMessage = ChatMessage(
      text: 'Quiero saber sobre $characterName',
      isUser: true,
      timestamp: DateTime.now(),
    );
    _service.addChatMessage(userMessage);

    // Buscar el personaje
    _service.getCharactersByName(characterName);
  }

  void _onMainCharactersPressed() {
    final userMessage = ChatMessage(
      text: 'Muéstrame los personajes principales',
      isUser: true,
      timestamp: DateTime.now(),
    );
    _service.addChatMessage(userMessage);
    _service.getMainCharacters();
  }

  void _addCharacterResponse(List<Character> characters, String query) {
    String responseText = '';
    
    if (query.contains('personajes principales')) {
      responseText = 'Aquí tienes los personajes principales de Rick and Morty:';
    } else if (query.contains('personaje aleatorio')) {
      responseText = 'Aquí tienes un personaje aleatorio:';
    } else if (query.contains('Quiero saber sobre')) {
      String characterName = query.replaceAll('Quiero saber sobre ', '');
      responseText = 'Aquí tienes información sobre $characterName:';
    } else {
      responseText = 'Aquí tienes los personajes encontrados:';
    }
    
    final responseMessage = ChatMessage(
      text: responseText,
      isUser: false,
      timestamp: DateTime.now(),
      characters: characters,
    );
    _service.addChatMessage(responseMessage);
  }

  void _onRandomCharactersPressed() {
    final userMessage = ChatMessage(
      text: 'Muéstrame un personaje aleatorio',
      isUser: true,
      timestamp: DateTime.now(),
    );
    _service.addChatMessage(userMessage);
    _service.getRandomCharacters();
  }

  void _showCharacterDetails(Character character) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF16213E),
        title: Text(
          character.name,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  character.image,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
                      width: 150,
                      color: Colors.grey[600],
                      child: Icon(Icons.person, color: Colors.white, size: 60),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            _buildDetailRow('Estado', character.status, _getStatusColor(character.status)),
            _buildDetailRow('Especie', character.species),
            _buildDetailRow('Género', character.gender),
            _buildDetailRow('Origen', character.origin.name),
            _buildDetailRow('Ubicación', character.location.name),
            if (character.type.isNotEmpty)
              _buildDetailRow('Tipo', character.type),
            _buildDetailRow('Episodios', '${character.episode.length} episodios'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cerrar',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, [Color? statusColor]) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (statusColor != null) ...[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 4),
          ],
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _charactersSubscription.cancel();
    _loadingSubscription.cancel();
    _errorSubscription.cancel();
    _chatSubscription.cancel();
    _scrollController.dispose();
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A2E),
      appBar: AppBar(
        title: Text(
          'Rick & Morty Chat',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF16213E),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Botones de acción rápida
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF16213E),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        'Personajes Principales',
                        Icons.star,
                        _onMainCharactersPressed,
                        Color(0xFF0F3460),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildActionButton(
                        'Personaje Aleatorio',
                        Icons.shuffle,
                        _onRandomCharactersPressed,
                        Color(0xFF533483),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  'O selecciona un personaje específico:',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    'Rick Sanchez',
                    'Morty Smith',
                    'Summer Smith',
                    'Beth Smith',
                    'Jerry Smith',
                  ].map((name) => _buildCharacterChip(name)).toList(),
                ),
              ],
            ),
          ),
          
          // Área del chat
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Color(0xFF0F3460),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    // Mensajes del chat
                    ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return _buildChatMessage(message);
                      },
                    ),
                    
                    // Indicador de carga
                    if (_isLoading)
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Buscando...',
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          
          // Mensaje de error
          if (_errorMessage.isNotEmpty)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red[100], fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon, VoidCallback onPressed, Color color) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        text,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildCharacterChip(String name) {
    return ActionChip(
      label: Text(
        name,
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: Color(0xFF533483),
      onPressed: () => _onCharacterButtonPressed(name),
      avatar: Icon(Icons.person, color: Colors.white, size: 16),
    );
  }

  Widget _buildChatMessage(ChatMessage message) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.isUser) Spacer(),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: message.isUser ? Color(0xFF533483) : Color(0xFF16213E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  _formatTime(message.timestamp),
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                ),
                // Mostrar personajes si están disponibles
                if (message.characters != null && message.characters!.isNotEmpty) ...[
                  SizedBox(height: 12),
                  Text(
                    'Personajes encontrados:',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  // Contenedor dinámico para los personajes
                  Container(
                    width: double.infinity,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: message.characters!.map((character) {
                        return CharacterCard(
                          character: character,
                          isCompact: true,
                          onTap: () => _showCharacterDetails(character),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (!message.isUser) Spacer(),
        ],
      ),
    );
  }



  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'alive':
        return Colors.green;
      case 'dead':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
