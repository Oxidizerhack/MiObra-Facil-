import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/work_catalog.dart';

class SelectItemScreen extends StatefulWidget {
  final String projectId;
  const SelectItemScreen({super.key, required this.projectId});

  @override
  State<SelectItemScreen> createState() => _SelectItemScreenState();
}

class _SelectItemScreenState extends State<SelectItemScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredCatalog = workCatalog.map((category) {
      final filteredItems = category.items.where((item) {
        return item.description.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
      return category.copyWith(items: filteredItems);
    }).where((category) => category.items.isNotEmpty).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Partida'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar partida',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCatalog.length,
              itemBuilder: (context, categoryIndex) {
                final category = filteredCatalog[categoryIndex];
                return ExpansionTile(
                  title: Text(category.category, style: Theme.of(context).textTheme.titleLarge),
                  children: category.items.map((item) {
                    return ListTile(
                      title: Text(item.description),
                      subtitle: Text('Unidad: ${item.unit}'),
                      onTap: () => context.go('/project/${widget.projectId}/calculate/${item.id}'),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
