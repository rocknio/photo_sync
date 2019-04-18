import 'package:event_bus/event_bus.dart';

// 全局event bus
EventBus eventBus = new EventBus();

// sync done event
class SyncDoneEvent {
	String syncedEntityId;
	bool syncResult;

	SyncDoneEvent(this.syncResult, this.syncedEntityId);
}

// count down event
class CountDownEvent {
	int step;

	CountDownEvent(this.step);
}
