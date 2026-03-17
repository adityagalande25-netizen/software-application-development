import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../utils/constants.dart';
import '../../widgets/app_menu_drawer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final _db = DatabaseService();
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bloodGroupController = TextEditingController();
  final _addressController = TextEditingController();
  final _medicalNotesController = TextEditingController();
  final _avatarUrlController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = _auth.currentUser;
    if (user == null) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      return;
    }

    try {
      final data = await _db.getUserProfile(user.uid);
      _nameController.text = (data?['name'] as String?) ?? user.displayName ?? '';
      _phoneController.text = (data?['phone'] as String?) ?? '';
      _bloodGroupController.text = (data?['bloodGroup'] as String?) ?? '';
      _addressController.text = (data?['address'] as String?) ?? '';
      _medicalNotesController.text = (data?['medicalNotes'] as String?) ?? '';
      _avatarUrlController.text = (data?['profileImageUrl'] as String?) ?? '';
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not load profile data')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      await _db.updateUserProfile(user.uid, {
        'uid': user.uid,
        'email': user.email,
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'bloodGroup': _bloodGroupController.text.trim(),
        'address': _addressController.text.trim(),
        'medicalNotes': _medicalNotesController.text.trim(),
        'profileImageUrl': _avatarUrlController.text.trim(),
        'updatedAt': DateTime.now().toIso8601String(),
      });

      await user.updateDisplayName(_nameController.text.trim());

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save profile: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _bloodGroupController.dispose();
    _addressController.dispose();
    _medicalNotesController.dispose();
    _avatarUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: const AppMenuDrawer(currentRoute: AppRoutes.profile),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _AnimatedProfileHeader(
                    name: _nameController.text.isEmpty ? (user?.displayName ?? 'User') : _nameController.text,
                    email: user?.email ?? 'No email',
                    avatarUrl: _avatarUrlController.text,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _avatarUrlController,
                    decoration: const InputDecoration(
                      labelText: 'Profile Image URL',
                      prefixIcon: Icon(Icons.image_outlined),
                      hintText: 'https://example.com/photo.jpg',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) => (value == null || value.trim().isEmpty) ? 'Name is required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    validator: (value) => (value == null || value.trim().isEmpty) ? 'Phone number is required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _bloodGroupController,
                    decoration: const InputDecoration(
                      labelText: 'Blood Group',
                      prefixIcon: Icon(Icons.bloodtype_outlined),
                      hintText: 'A+, B+, O-, etc.',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _medicalNotesController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Medical Notes',
                      prefixIcon: Icon(Icons.medical_information_outlined),
                      hintText: 'Allergies, conditions, medications',
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _isSaving ? null : _saveProfile,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save_outlined),
                    label: Text(_isSaving ? 'Saving...' : 'Save Profile'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.red.shade700,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _AnimatedProfileHeader extends StatefulWidget {
  final String name;
  final String email;
  final String avatarUrl;

  const _AnimatedProfileHeader({
    required this.name,
    required this.email,
    required this.avatarUrl,
  });

  @override
  State<_AnimatedProfileHeader> createState() => _AnimatedProfileHeaderState();
}

class _AnimatedProfileHeaderState extends State<_AnimatedProfileHeader> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.lerp(Colors.red.shade700, Colors.red.shade500, t)!,
                Color.lerp(Colors.orange.shade700, Colors.red.shade800, t)!,
              ],
              begin: Alignment(-1 + (t * 0.4), -1),
              end: Alignment(1, 1 - (t * 0.3)),
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: Colors.white,
                foregroundImage: widget.avatarUrl.trim().isEmpty ? null : NetworkImage(widget.avatarUrl.trim()),
                child: widget.avatarUrl.trim().isEmpty
                    ? Text(
                        widget.name.isNotEmpty ? widget.name[0].toUpperCase() : 'U',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.email,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
