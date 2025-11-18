import 'package:flutter/material.dart';

/// Reusable widget for numeric input fields with validation
class NumericFormField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final double minValue;
  final double maxValue;
  final String? errorText;
  final Function(String) onChanged;

  const NumericFormField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.minValue,
    required this.maxValue,
    this.errorText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          errorText: errorText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        onChanged: onChanged,
      ),
    );
  }
}

/// Reusable widget for dropdown fields
class DropdownFormField extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final Function(String?) onChanged;
  final String? errorText;

  const DropdownFormField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

/// Reusable widget for multi-select amenities
class AmenitiesSelector extends StatefulWidget {
  final List<String> options;
  final Function(List<String>) onSelectionChanged;

  const AmenitiesSelector({
    super.key,
    required this.options,
    required this.onSelectionChanged,
  });

  @override
  State<AmenitiesSelector> createState() => _AmenitiesSelectorState();
}

class _AmenitiesSelectorState extends State<AmenitiesSelector> {
  List<String> _selectedAmenities = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Amenities',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        ...widget.options.map((amenity) {
          return CheckboxListTile(
            title: Text(amenity),
            value: _selectedAmenities.contains(amenity),
            onChanged: (bool? value) {
              setState(() {
                if (value == true) {
                  _selectedAmenities.add(amenity);
                } else {
                  _selectedAmenities.remove(amenity);
                }
                widget.onSelectionChanged(_selectedAmenities);
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          );
        }).toList(),
      ],
    );
  }
}

/// Widget to display the prediction result
class PredictionResultCard extends StatelessWidget {
  final double predictedRent;

  const PredictionResultCard({
    super.key,
    required this.predictedRent,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.green[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Predicted Rent',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${predictedRent.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget to display error messages
class ErrorMessageCard extends StatelessWidget {
  final String errorMessage;

  const ErrorMessageCard({
    super.key,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.red[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                errorMessage,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
