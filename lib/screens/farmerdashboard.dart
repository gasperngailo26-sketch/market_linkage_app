import 'package:flutter/material.dart';
import 'package:market_linkage_application/screens/welcome%20page.dart'
    show WelcomePage;

class ProductPost {
  final String title;
  final String category;
  final String description;
  final String quantity;
  final String timeToWarehouse;
  final String warehouseLocation;
  final String phoneNumber;
  final String? imageLabel;

  ProductPost({
    required this.title,
    required this.category,
    required this.description,
    required this.quantity,
    required this.timeToWarehouse,
    required this.warehouseLocation,
    required this.phoneNumber,
    this.imageLabel,
  });
}

class FarmerDashboard extends StatefulWidget {
  final String name;
  final String farmerType;
  final String location;

  const FarmerDashboard({
    super.key,
    required this.name,
    required this.farmerType,
    required this.location,
  });

  @override
  State<FarmerDashboard> createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _timeController = TextEditingController();
  final _warehouseController = TextEditingController();
  final _phoneController = TextEditingController();
  String _category = 'Food';
  String? _selectedImageLabel;
  final List<ProductPost> _posts = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _timeController.dispose();
    _warehouseController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _selectImage() {
    setState(() {
      _selectedImageLabel = 'Product image selected';
    });
  }

  void _postProduct() {
    if (_formKey.currentState?.validate() ?? false) {
      final post = ProductPost(
        title: _titleController.text.trim(),
        category: _category,
        description: _descriptionController.text.trim(),
        quantity: _quantityController.text.trim(),
        timeToWarehouse: _timeController.text.trim(),
        warehouseLocation: _warehouseController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        imageLabel: _selectedImageLabel,
      );

      setState(() {
        _posts.insert(0, post);
        _titleController.clear();
        _descriptionController.clear();
        _quantityController.clear();
        _timeController.clear();
        _warehouseController.clear();
        _phoneController.clear();
        _selectedImageLabel = null;
        _category = 'Food';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product posted successfully')),
      );
    }
  }

  Widget _buildImagePreview() {
    return Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Center(
        child: _selectedImageLabel == null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.image_outlined, size: 48, color: Colors.green),
                  SizedBox(height: 8),
                  Text('No image selected'),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 48,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 8),
                  Text(_selectedImageLabel!),
                ],
              ),
      ),
    );
  }

  Widget _buildPostCard(ProductPost post) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: const Icon(
                    Icons.agriculture,
                    size: 42,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(post.category, style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(
                        'Qty: ${post.quantity}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(post.description, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            Text(
              'Harvest → Warehouse: ${post.timeToWarehouse}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'Warehouse: ${post.warehouseLocation}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'Phone: ${post.phoneNumber}',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmer Dashboard'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WelcomePage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Welcome, ${widget.name}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Type: ${widget.farmerType}',
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            'Location: ${widget.location}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Post a product',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Product title',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter product title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _category,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Food', child: Text('Food')),
                        DropdownMenuItem(
                          value: 'Commercial Crop',
                          child: Text('Commercial Crop'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _category = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'Tell buyers about your product',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _quantityController,
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        hintText: 'e.g. 200 kg, 5 sacks',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter quantity';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _timeController,
                      decoration: const InputDecoration(
                        labelText: 'Time from harvest to warehouse',
                        hintText: 'e.g. 2 days',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter time to warehouse';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _warehouseController,
                      decoration: const InputDecoration(
                        labelText: 'Warehouse location',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter warehouse location';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone number',
                        hintText: '+123456789',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildImagePreview(),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _selectImage,
                            icon: const Icon(Icons.upload_file),
                            label: const Text('Upload image'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _postProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14.0),
                        child: Text(
                          'Post product',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Posted products',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (_posts.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'No products posted yet. Use the form above to create a new listing.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            )
          else
            ..._posts.map(_buildPostCard),
        ],
      ),
    );
  }
}
