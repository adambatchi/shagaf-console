import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shagf_console/core/providers/products_provider.dart';
import 'package:shagf_console/screens/products/add_product.dart';
import 'package:shagf_console/screens/products/edit_product.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();

    setState(() {
      final productsProvider = context.read<ProductsProvider>();
      productsProvider.getItemsFromDB();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = context.watch<ProductsProvider>();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: const [
          CircleAvatar(
              backgroundColor: Colors.black,
              backgroundImage: NetworkImage(
                "https://cdn.pixabay.com/photo/2018/08/28/12/41/avatar-3637425__340.png",
              )),
          SizedBox(width: 20),
        ],
        title: const Text(
          "Shagf admin panel",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AddProduct()));
          });
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const Text(
            "Products",
            style: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (var item in productsProvider.products)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          elevation: 6,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 300,
                                width: 400,
                                child: FutureBuilder<Uri>(
                                  future: productsProvider.downloadURL(context, item.imgURL!),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.done) {
                                      return SizedBox(
                                        height: 300,
                                        width: 200,
                                        child: Card(
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                          child: Image.network(
                                            snapshot.data.toString(),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    }

                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const SizedBox(
                                        height: 300,
                                        child: Center(child: CircularProgressIndicator()),
                                      );
                                    }

                                    return Container();
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "name : " + item.name,
                                  style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("price : " + item.price.toString(), style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("category : " + item.category!, style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProduct(item: item),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.edit),
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
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.

    super.dispose();
  }
}
