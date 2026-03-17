import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/database_service.dart';
import '../../models/emergency_contact_model.dart';
import '../../utils/constants.dart';
import '../../widgets/app_menu_drawer.dart';
import 'package:uuid/uuid.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() => _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  final _databaseService = DatabaseService();
  final _auth = FirebaseAuth.instance;
  late Stream<List<EmergencyContact>> _contactsStream;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  void _loadContacts() {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      _contactsStream = _databaseService.getEmergencyContacts(userId).asStream().map((contacts) {
        return contacts;
      });
    }
  }

  Future<void> _addContact(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final relationshipController = TextEditingController();
    int priority = 1;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Emergency Contact'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) => value?.isEmpty ?? true ? 'Name is required' : null,
                  ),
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: 'Phone Number'),
                    keyboardType: TextInputType.phone,
                    validator: (value) => value?.isEmpty ?? true ? 'Phone is required' : null,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email (optional)'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextFormField(
                    controller: relationshipController,
                    decoration: const InputDecoration(labelText: 'Relationship'),
                    validator: (value) => value?.isEmpty ?? true ? 'Relationship is required' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField(
                    value: priority,
                    decoration: const InputDecoration(labelText: 'Priority'),
                    items: List.generate(
                      5,
                      (index) => DropdownMenuItem(
                        value: index + 1,
                        child: Text('${index + 1}'),
                      ),
                    ),
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => priority = value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final userId = _auth.currentUser?.uid;
                  if (userId != null) {
                    final contact = EmergencyContact(
                      id: const Uuid().v4(),
                      userId: userId,
                      name: nameController.text,
                      phone: phoneController.text,
                      email: emailController.text.isEmpty ? null : emailController.text,
                      relationship: relationshipController.text,
                      priority: priority,
                      createdAt: DateTime.now(),
                    );
                    await _databaseService.addEmergencyContact(contact);
                    if (mounted) {
                      Navigator.pop(context);
                      _loadContacts();
                      setState(() {});
                    }
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = _auth.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: const AppMenuDrawer(currentRoute: AppRoutes.contacts),
      body: userId == null
          ? const Center(child: Text('User not authenticated'))
          : FutureBuilder<List<EmergencyContact>>(
              future: _databaseService.getEmergencyContacts(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final contacts = snapshot.data ?? [];

                if (contacts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.contacts, size: 80, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        const Text('No emergency contacts added yet'),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => _addContact(context),
                          icon: const Icon(Icons.add),
                          label: const Text('Add First Contact'),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text('${contact.priority}'),
                        ),
                        title: Text(contact.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(contact.phone),
                            Text(contact.relationship, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              onTap: () {
                                Future.delayed(Duration.zero, () => _addContact(context));
                              },
                              child: const Text('Edit'),
                            ),
                            PopupMenuItem(
                              onTap: () async {
                                await _databaseService.deleteEmergencyContact(userId, contact.id);
                                setState(() {});
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addContact(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
