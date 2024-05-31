import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'presentation/routes/app.dart';

void main() => runApp(
      const ProviderScope(
        child: BetApp(),
      ),
    );
