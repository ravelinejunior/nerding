import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ImageSliderScreen extends StatefulWidget {
  final String itemColor;
  final String title;
  final String userNumber;
  final String description;
  final double lat;
  final double long;
  final String address;
  final List<dynamic> urlImage;

  const ImageSliderScreen({
    required this.itemColor,
    required this.title,
    required this.userNumber,
    required this.description,
    required this.lat,
    required this.long,
    required this.address,
    required this.urlImage,
  });

  @override
  _ImageSliderScreenState createState() => _ImageSliderScreenState();
}

class _ImageSliderScreenState extends State<ImageSliderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontFamily: 'Varela'),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 8,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_pin, color: Colors.orangeAccent),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      widget.address,
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        fontFamily: 'Varela',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(8),
              child: CarouselSlider(
                items: widget.urlImage
                    .map((image) => ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: image,
                            height: 220,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                        ))
                    .toList(),
                options: CarouselOptions(
                  height: 400,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Icon(Icons.brush_outlined),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Align(
                          child: Text(widget.itemColor),
                          alignment: Alignment.topLeft,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.phone_android_rounded),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Align(
                          child: Text(widget.userNumber),
                          alignment: Alignment.topLeft,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                widget.description,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 368),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Localização do Vendedor'),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
