import 'package:flutter/material.dart';

import '../models/character.dart';

class CharacterCard extends StatelessWidget {
  final Character character;
  final VoidCallback? onTap;
  final bool isCompact;

  const CharacterCard({
    super.key,
    required this.character,
    this.onTap,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return _buildCompactCard();
    }
    return _buildFullCard();
  }

  Widget _buildCompactCard() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 120,
        decoration: BoxDecoration(
          color: Color(0xFF16213E),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                character.image,
                height: 70,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 70,
                    color: Colors.grey[600],
                    child: Icon(Icons.person, color: Colors.white, size: 25),
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: _getStatusColor(character.status),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            character.status,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 8,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullCard() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        margin: EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Color(0xFF16213E),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                character.image,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 120,
                    color: Colors.grey[600],
                    child: Icon(Icons.person, color: Colors.white, size: 50),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    character.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _getStatusColor(character.status),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        character.status,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    character.species,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  if (character.type.isNotEmpty) ...[
                    SizedBox(height: 4),
                    Text(
                      character.type,
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white60, size: 14),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          character.origin.name,
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 10,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
}
