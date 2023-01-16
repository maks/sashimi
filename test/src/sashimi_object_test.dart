// ignore_for_file: cascade_invocations

import 'package:flutter_test/flutter_test.dart';
import 'package:sashimi/sashimi.dart';

import '../helpers/helpers.dart';

class _TestObject extends SashimiObject {
  _TestObject() : super(position: Vector3.zero(), size: Vector3.zero()) {
    addListener(listener);
  }

  @override
  List<SashimiSlice<SashimiObject>> generateSlices() {
    return [_TestSlice(owner: this)];
  }

  void listener() => listenerCalled = true;

  bool listenerCalled = false;
}

class _TestSlice extends SashimiSlice<_TestObject> {
  _TestSlice({
    required super.owner,
  });
}

void main() {
  group('SashimiObject', () {
    sashimiGame.testGameWidget(
      'sets angle to object and controller',
      setUp: (game, tester) => game.ensureAdd(_TestObject()),
      verify: (game, tester) async {
        final object = game.descendants().whereType<_TestObject>().first;
        object.angle = 10;

        expect(object.angle, equals(10));
        expect(object.controller.angle, equals(10));
      },
    );

    sashimiGame.testGameWidget(
      'retrieves slices generated by generateSlices',
      setUp: (game, tester) => game.ensureAdd(_TestObject()),
      verify: (game, tester) async {
        final object = game.descendants().whereType<_TestObject>().first;

        expect(object.slices.length, equals(1));
      },
    );

    sashimiGame.testGameWidget(
      'calls listener on onLoad',
      setUp: (game, tester) => game.ensureAdd(_TestObject()),
      verify: (game, tester) async {
        final object = game.descendants().whereType<_TestObject>().first;

        expect(object.isLoaded, equals(true));
        expect(object.listenerCalled, equals(true));
      },
    );

    sashimiGame.testGameWidget(
      'calls listener on position change',
      setUp: (game, tester) => game.ensureAdd(_TestObject()),
      verify: (game, tester) async {
        final object = game.descendants().whereType<_TestObject>().first;
        object.listenerCalled = false; // Is set to true in onLoad.

        object.position.setValues(10, 10, 10);
        expect(object.listenerCalled, equals(true));
      },
    );

    sashimiGame.testGameWidget(
      'calls listener on size change',
      setUp: (game, tester) => game.ensureAdd(_TestObject()),
      verify: (game, tester) async {
        final object = game.descendants().whereType<_TestObject>().first;
        object.listenerCalled = false; // Is set to true in onLoad.

        object.size.setValues(10, 10, 10);
        expect(object.listenerCalled, equals(true));
      },
    );

    sashimiGame.testGameWidget(
      'calls listener on scale change',
      setUp: (game, tester) => game.ensureAdd(_TestObject()),
      verify: (game, tester) async {
        final object = game.descendants().whereType<_TestObject>().first;
        object.listenerCalled = false; // Is set to true in onLoad.

        object.scale.setValues(10, 10, 10);
        expect(object.listenerCalled, equals(true));
      },
    );

    sashimiGame.testGameWidget(
      'calls listener on angle change',
      setUp: (game, tester) => game.ensureAdd(_TestObject()),
      verify: (game, tester) async {
        final object = game.descendants().whereType<_TestObject>().first;
        object.listenerCalled = false; // Is set to true in onLoad.

        object.angle = 0;
        expect(object.listenerCalled, equals(true));
      },
    );

    sashimiGame.testGameWidget(
      'stops listener when unmounted',
      setUp: (game, tester) => game.ensureAdd(_TestObject()),
      verify: (game, tester) async {
        final object = game.descendants().whereType<_TestObject>().first;
        object.listenerCalled = false; // Is set to true in onLoad.

        object.removeFromParent();
        game.update(0); // Simulate next tick

        object.scale.setValues(10, 10, 10);
        expect(object.listenerCalled, equals(false));
      },
    );
  });
}
