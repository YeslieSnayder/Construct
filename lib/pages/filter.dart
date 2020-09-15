import 'package:construct/model/item.dart';
import 'package:flutter/material.dart';

import '../constant.dart';

class FilterPage {
  FilterPage({this.context, this.stream, this.items, this.setState});

  List<Item> items;
  final StateSetter setState;
  final Stream<List<Item>> stream;

  final BuildContext context;

  static double MIN_PRICE = 8560;
  static double MAX_PRICE = 130000;
  RangeValues priceFilterValue = RangeValues(MIN_PRICE, MAX_PRICE);
  RangeLabels _priceLabels = RangeLabels('${MIN_PRICE.toInt()} руб.', '${MAX_PRICE.toInt()} руб.');

  final List<String> _organizations = ['Abus', 'LG Energy', 'Ecovolt'];
  final Map<String, TextEditingController> _features = {
    'Бренд': TextEditingController(),
    'Номинальная мощность': TextEditingController(),
    'Номинальное напряжение': TextEditingController(),
    'Тип солнечных модулей': TextEditingController(),
  };

  List<String> filterCompanies = [];
  Map<String, dynamic> _filterFeatures = {};

  build() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 100.0),
                      _priceFilter(setState),
                      Divider(),
                      SizedBox(height: 5.0),
                      _orgFilter(setState),
                      Divider(),
                      SizedBox(height: 5.0),
                      _featureFilter(setState),
                      SizedBox(height: 100.0),
                    ],
                  ),
                ),
                _buildFab(),
              ],
            );
          },
        ));
  }

  _priceFilter(StateSetter setState) {
    _setOrGetMinAndMaxPrice(setState);
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: Text(
            'Цена',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 20.0,
            ),
          ),
        ),
        RangeSlider(
          min: MIN_PRICE,
          max: MAX_PRICE,
          values: priceFilterValue,
          divisions: 20,
          labels: _priceLabels,
          onChanged: (val) {
            setState(() {
              priceFilterValue = val;
              _priceLabels = RangeLabels(
                  '${val.start.toInt()} руб.',
                  '${val.end.toInt()} руб.'
              );
            });
          },
        )
      ],
    );
  }

  _orgFilter(StateSetter setState) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: Text(
            'Поставщик',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 20.0,
            ),
          ),
        ),
        Wrap(
          children: organizationWidgets(setState).toList(),
        ),
      ],
    );
  }

  _featureFilter(StateSetter setState) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: Text(
            'Характеристики',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 20.0,
            ),
          ),
        ),
        Wrap(
          children: featureWidgets(setState).toList(),
        )
      ],
    );
  }

  Iterable<Widget> organizationWidgets(StateSetter setState) sync* {
    for (String org in _organizations) {
      yield Padding(
        padding: const EdgeInsets.all(6.0),
        child: FilterChip(
          elevation: 6.0,
          avatar: CircleAvatar(
            child: Text(org[0].toUpperCase()),
            backgroundColor: kPrimaryColor,
          ),
          label: Text(org),
          selected: filterCompanies.contains(org),
          onSelected: (selected) {
            setState(() {
              if (selected)
                filterCompanies.add(org);
              else
                filterCompanies.removeWhere((name) => name == org);
            });
          },
        ),
      );
    }
  }

  Iterable<Widget> featureWidgets(StateSetter setState) sync* {
    for (var feature in _features.entries) {
      yield Padding(
        padding: const EdgeInsets.all(6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 2,
              child: Text(
                feature.key,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16.0,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 3,
              child: TextFormField(
                controller: feature.value,
                decoration: InputDecoration(
                    fillColor: kExtraColor,
                    border: OutlineInputBorder(
                      gapPadding: 1.0,
                    )),
                onSaved: (val) => feature.value.text = val,
                onChanged: (text) {
                  setState(() {
                    if (text.isEmpty &&
                        _filterFeatures.containsKey(feature.key))
                      _filterFeatures.remove(feature.key);
                    else
                      _filterFeatures[feature.key] = text;
                  });
                },
              ),
            ),
          ],
        ),
      );
    }
  }

  _buildFab() {
    final fullHeight = MediaQuery.of(context).size.height;
    final top = fullHeight - fullHeight / 8;

    return Positioned(
      child: FloatingActionButton(
        child: Icon(
          Icons.filter_list,
          color: Colors.white,
        ),
        backgroundColor: kButtonColor,
        onPressed: () {
          stream.listen((data) {
            items = data;
          });
          Navigator.pop(context);
        },
      ),
      top: top,
      right: 24.0,
    );
  }

  void _setOrGetMinAndMaxPrice(setState) {
    //TODO
  }
}