import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/villa_provider.dart';
import 'property_detail_screen.dart';

class ClaimedVillaScreen extends StatefulWidget {
  const ClaimedVillaScreen({Key? key}) : super(key: key);

  @override
  State<ClaimedVillaScreen> createState() => _ClaimedVillaScreenState();
}

class _ClaimedVillaScreenState extends State<ClaimedVillaScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<VillaProvider>().getClaimedVillas();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VillaProvider>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Claimed Villas'),
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      backgroundColor: Colors.grey[50],
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.claimedVillas.isEmpty
          ? const Center(
        child: Text(
          'No claimed villas found',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.builder(
          itemCount: provider.claimedVillas.length,
          itemBuilder: (context, index) {
            final villa = provider.claimedVillas[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PropertyDetailScreen(
                      villaId: villa['id'].toString(),
                    ),
                  ),
                );
              },
              child: Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.teal.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.villa, color: Colors.white, size: 32),
                      ),
                      const SizedBox(width: 16),
                      // Villa info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              villa['name'] ?? 'Villa',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Distance: ${villa['distance'] ?? '-'} m',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Business Unit ID: ${villa['business_unit_id'] ?? '-'}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
