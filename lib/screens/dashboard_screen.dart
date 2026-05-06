import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/index.dart';
import '../providers/index.dart';
import '../utils/index.dart';
import '../widgets/index.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final eventProvider = context.watch<EventProvider>();
    final allEvents = eventProvider.allEvents;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crowd Monitoring Dashboard'),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Connectivity Banner
          Consumer<ConnectivityProvider>(
            builder: (context, connectivity, _) =>
                ConnectivityBanner(isConnected: connectivity.isConnected),
          ),
          Expanded(
            child: allEvents.isEmpty
                ? _buildNoEventsWidget()
                : _buildDashboardContent(allEvents),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade700,
        onPressed: () => Navigator.pushNamed(context, '/setup'),
        tooltip: 'Create Event',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildNoEventsWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_note, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Events Yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first event to get started',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Create Event',
            onPressed: () => Navigator.pushNamed(context, '/setup'),
            width: 200,
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(List<Event> allEvents) {
    final checkInProvider = context.watch<CheckInProvider>();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: allEvents.length,
      itemBuilder: (context, index) {
        final event = allEvents[index];
        final checkedInCount = checkInProvider.getEventCheckInCount(event.id);
        final crowdLevel = CrowdLevelUtils.getCrowdLevel(
          checkedInCount,
          event.maxCapacity,
        );
        final crowdColor = CrowdLevelUtils.getCrowdLevelColor(
          checkedInCount,
          event.maxCapacity,
        );
        final crowdIcon =
            CrowdLevelUtils.getCrowdIcon(checkedInCount, event.maxCapacity);
        final percentage = CrowdLevelUtils.getCrowdPercentage(
          checkedInCount,
          event.maxCapacity,
        );
        final remainingCapacity = event.maxCapacity - checkedInCount;

        return GestureDetector(
          onTap: () {
            context.read<EventProvider>().setCurrentEvent(event);
            Navigator.pushNamed(context, '/checkin');
          },
          child: Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.eventName,
                              style: Theme.of(context).textTheme.titleLarge,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateTimeUtils.formatDateTime(event.eventDate),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: const Text('View Details'),
                            onTap: () {
                              context.read<EventProvider>().setCurrentEvent(event);
                              Navigator.pushNamed(context, '/logs');
                            },
                          ),
                          PopupMenuItem(
                            child: const Text('Edit'),
                            onTap: () {
                              final nameController = TextEditingController(text: event.eventName);
                              final capacityController = TextEditingController(text: event.maxCapacity.toString());
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Edit Event'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: nameController,
                                        decoration: const InputDecoration(labelText: 'Event Name'),
                                      ),
                                      TextField(
                                        controller: capacityController,
                                        decoration: const InputDecoration(labelText: 'Max Capacity'),
                                        keyboardType: TextInputType.number,
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        final newName = nameController.text.trim();
                                        final newCapacity = int.tryParse(capacityController.text.trim()) ?? event.maxCapacity;
                                        if (newName.isNotEmpty) {
                                          await context.read<EventProvider>().updateEvent(event, newName, newCapacity);
                                          if (ctx.mounted) Navigator.pop(ctx);
                                        }
                                      },
                                      child: const Text('Save'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          PopupMenuItem(
                            child: const Text('Delete'),
                            onTap: () {
                              showCustomDialog(
                                context,
                                title: 'Delete Event',
                                message: 'Are you sure you want to delete this event?',
                                cancelButtonLabel: 'Cancel',
                                buttonLabel: 'Delete',
                                isDangerous: true,
                                onConfirm: () {
                                  context
                                      .read<EventProvider>()
                                      .deleteEvent(event.id);
                                  showCustomSnackBar(
                                    context,
                                    message: 'Event deleted',
                                    type: SnackBarType.success,
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Crowd Status
                  CrowdLevelCard(
                    checkedIn: checkedInCount,
                    maxCapacity: event.maxCapacity,
                    crowdLevel: crowdLevel,
                    crowdColor: crowdColor,
                    crowdIcon: crowdIcon,
                    percentage: percentage,
                  ),
                  const SizedBox(height: 16),

                  // Statistics Row
                  Row(
                    children: [
                      Expanded(
                        child: StatisticCard(
                          title: 'Checked In',
                          value: checkedInCount.toString(),
                          icon: Icons.check_circle,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatisticCard(
                          title: 'Available',
                          value: remainingCapacity.toString(),
                          icon: Icons.person_add,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatisticCard(
                          title: 'Capacity',
                          value: event.maxCapacity.toString(),
                          icon: Icons.group,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        context.read<EventProvider>().setCurrentEvent(event);
                        Navigator.pushNamed(context, '/checkin');
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_add),
                          SizedBox(width: 8),
                          Text('Check In Participants'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
