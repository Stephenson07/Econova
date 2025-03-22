import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool _isUploading = false;
  bool _isAnalyzing = false;
  String _statusMessage = '';
  Map<String, dynamic>? _analysisResult;
  String? _imageName;
  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  Widget _buildEwasteAnalysisCard({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.3), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(content, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  // Initial empty state widget
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 80, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'Capture E-Waste',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'Take a photo or select an image of electronic waste to identify its components and recycling information',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.camera_alt),
                label: Text('Take Photo'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onPressed: _isUploading || _isAnalyzing ? null : _openCamera,
              ),
              SizedBox(width: 16),
              ElevatedButton.icon(
                icon: Icon(Icons.photo_library),
                label: Text('Gallery'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onPressed: _isUploading || _isAnalyzing ? null : _pickImage,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Pick an image from the gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      _setImage(File(pickedFile.path), pickedFile.name);
    }
  }

  // Capture an image using the camera
  Future<void> _openCamera() async {
    final XFile? capturedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );
    if (capturedFile != null) {
      _setImage(File(capturedFile.path), capturedFile.name);
    }
  }

  // Set the selected image
  void _setImage(File image, String name) {
    setState(() {
      _selectedImage = image;
      _imageName = name;
      // Only for display
    });
    _uploadFile(image);
  }

  // Upload image to server
  Future<void> _uploadFile(File file) async {
    setState(() {
      _isUploading = true;
      _statusMessage = 'Uploading image...';
      _analysisResult = null;
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.1.48:5000/upload'),
      );
      request.files.add(await http.MultipartFile.fromPath('images', file.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        setState(() {
          _isUploading = false;
          _statusMessage = 'Image uploaded successfully';
        });
        _requestEwasteAnalysis(_imageName!);
      } else {
        setState(() {
          _isUploading = false;
          _statusMessage = 'Failed to upload image';
        });
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
        _statusMessage = 'Error: $e';
      });
    }
  }

  // Request e-waste analysis
  Future<void> _requestEwasteAnalysis(String filename) async {
    setState(() {
      _isAnalyzing = true;
      _statusMessage = 'Analyzing e-waste...';
    });

    try {
      var response = await http.get(
        Uri.parse('http://192.168.1.48:5000/analyze?filename=$filename'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isAnalyzing = false;
          _statusMessage = 'Analysis complete';
          _analysisResult = jsonDecode(response.body);
        });
      } else {
        setState(() {
          _isAnalyzing = false;
          _statusMessage = 'Failed to analyze image';
        });
      }
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
        _statusMessage = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(''), elevation: 0),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Show image if selected, otherwise show empty state
            if (_selectedImage != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  _selectedImage as File,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),
              if (_isUploading || _isAnalyzing) ...[
                LinearProgressIndicator(),
                SizedBox(height: 8),
              ],
              Text(
                _statusMessage,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              // Action buttons when an image is already selected
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.camera_alt),
                    label: Text('Take New Photo'),
                    onPressed:
                        _isUploading || _isAnalyzing ? null : _openCamera,
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.photo_library),
                    label: Text('New from Gallery'),
                    onPressed: _isUploading || _isAnalyzing ? null : _pickImage,
                  ),
                ],
              ),
            ] else
              // Show empty state when no image is selected
              _buildEmptyState(),

            SizedBox(height: 24),

            // Analysis results
            if (_analysisResult != null) ...[
              Divider(thickness: 1),
              SizedBox(height: 16),
              Text(
                'Analysis Results',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              SizedBox(height: 16),
              _buildEwasteAnalysisCard(
                title: 'E-Waste Type',
                content: _analysisResult!['type'] ?? 'Unknown',
                icon: Icons.category,
                color: Colors.blue[700]!,
              ),
              SizedBox(height: 16),
              _buildEwasteAnalysisCard(
                title: 'Elements Present',
                content: _analysisResult!['elements'] ?? 'No data available',
                icon: Icons.science,
                color: Colors.purple[700]!,
              ),
              SizedBox(height: 16),
              _buildEwasteAnalysisCard(
                title: 'Environmental Harm',
                content:
                    _analysisResult!['environmental_harm'] ??
                    'No data available',
                icon: Icons.warning_amber,
                color: Colors.red[700]!,
              ),
              SizedBox(height: 16),
              _buildEwasteAnalysisCard(
                title: 'Benefits of Recycling',
                content:
                    _analysisResult!['recycling_benefits'] ??
                    'No data available',
                icon: Icons.recycling,
                color: Colors.blue[700]!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
