import 'package:flutter/material.dart';
import 'package:flutter_place_with_riverpod/screens/place_detail_screen.dart';

import '../models/place.dart';

class PlaceList extends StatelessWidget {
  const PlaceList({
    super.key,
    required this.places,
  });

  final List<Place> places;

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return Center(
        child: Text(
          'No places added yet',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
      );
    }

    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (ctx, idx) => ListTile(
        leading: CircleAvatar(
          radius: 26,
          backgroundImage: FileImage(places[idx].image),
        ),
        title: Text(
          places[idx].title,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
        subtitle: Text(
          places[idx].location.address,
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => PlaceDetailScreen(place: places[idx]))),
      ),
    );
  }
}
