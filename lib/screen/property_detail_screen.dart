import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/villa_provider.dart';

class PropertyDetailScreen extends StatefulWidget {
  final String villaId;
  const PropertyDetailScreen({Key? key, required this.villaId}) : super(key: key);

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final provider = context.read<VillaProvider>();
      //  Fetch main villa details
      await provider.getPropertyDetail(widget.villaId);

      //  Fetch other villas from same BU
      final buId = provider.propertyDetail?['business_unit_id'];
      if (buId != null) {
        await provider.getBuPropertiesByVilla(buId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final villaProvider = context.watch<VillaProvider>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Property Details'),
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      backgroundColor: Colors.grey[50],
      body: villaProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : villaProvider.propertyDetail == null
          ? const Center(child: Text('No details found'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    villaProvider.propertyDetail?['image'] != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        villaProvider.propertyDetail!['image'],
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder:
                            (context, child, progress) {
                          if (progress == null) return child;
                          return const SizedBox(
                            height: 200,
                            child: Center(
                                child:
                                CircularProgressIndicator()),
                          );
                        },
                        errorBuilder: (context, error, stack) {
                          return Container(
                            height: 200,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.broken_image_outlined,
                              size: 50,
                            ),
                          );
                        },
                      ),
                    )
                        : Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.broken_image_outlined,
                        size: 50,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      villaProvider.propertyDetail?['name'] ?? '',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Latitude: ${villaProvider.propertyDetail?['latitude'] ?? '-'}',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      'Longitude: ${villaProvider.propertyDetail?['longitude'] ?? '-'}',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            //Other Villas from Same BU
            if (villaProvider.buProperties.isNotEmpty) ...[
              const Text(
                'Other Villas from this Business Unit',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: villaProvider.buProperties.length,
                  itemBuilder: (context, index) {
                    final villa = villaProvider.buProperties[index];

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
                      child: Container(
                        width: 160,
                        margin: const EdgeInsets.only(right: 12),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                child: villa['image'] != null
                                    ? Image.network(
                                  villa['image'],
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildImagePlaceholder();
                                  },
                                )
                                    : _buildImagePlaceholder(),
                              ),


                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  villa['name'] ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            ]
          ],
        ),
      ),
    );
  }
  Widget _buildImagePlaceholder() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.image_not_supported_outlined,
              size: 40,
              color: Colors.grey,
            ),
            SizedBox(height: 4),
            Text(
              'No Image',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
