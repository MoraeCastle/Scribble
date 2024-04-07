import 'package:flutter/cupertino.dart';

final routeObserver = RouteObserver();

/// 루트 감지...
class RouteObserver extends NavigatorObserver {
    final Set<RouteAware> _listeners = <RouteAware>{};

    void subscribe(RouteAware routeAware) {
        _listeners.add(routeAware);
    }

    void unsubscribe(RouteAware routeAware) {
        _listeners.remove(routeAware);
    }

    @override
    void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
        for (var listener in _listeners) {
            listener.didPop();
        }
    }
}