import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/app_button.dart';
import '../../common/app_motion.dart';
import '../../common/loading_state.dart';
import '../../common/responsive.dart';
import '../../constants/app_colors.dart';
import '../../controllers/content_controller.dart';
import '../../models/models.dart';

class ExerciseView extends StatefulWidget {
  const ExerciseView({super.key});

  @override
  State<ExerciseView> createState() => _ExerciseViewState();
}

class _ExerciseViewState extends State<ExerciseView> {
  int index = 0;
  String? selected;
  LessonModel? lesson;
  bool finishing = false;

  @override
  void initState() {
    super.initState();
    lesson = Get.arguments as LessonModel?;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && lesson != null) {
        Get.find<ContentController>().loadQuestions(lesson!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ContentController>();
    return Scaffold(
      appBar: AppBar(title: Text(lesson?.title ?? 'Exercise')),
      body: PageShell(
        child: Obx(() {
          if (c.loading.value) return const LoadingState();
          if (c.questions.isEmpty) {
            return const Center(child: Text('No questions available.'));
          }

          final q = c.questions[index.clamp(0, c.questions.length - 1)];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(value: (index + 1) / c.questions.length),
              const SizedBox(height: 20),
              Text(
                q.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              ...q.media
                  .where((m) => m.absoluteUrl != null)
                  .map((m) => _QuestionMedia(media: m)),
              const SizedBox(height: 12),
              Expanded(
                child: GameListView(
                  children: q.answers
                      .map(
                        (a) => Card(
                          color: selected == a.id ? AppColors.sand : null,
                          child: ListTile(
                            onTap: () => setState(() => selected = a.id),
                            leading: Icon(
                              selected == a.id
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                              color: selected == a.id ? AppColors.palm : null,
                            ),
                            title: Text(a.title.isEmpty ? 'Answer' : a.title),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              AppButton(
                label: index == c.questions.length - 1 ? 'Finish' : 'Next',
                loading: finishing,
                onPressed: finishing ? null : () => _nextOrFinish(c),
              ),
            ],
          );
        }),
      ),
    );
  }

  Future<void> _nextOrFinish(ContentController c) async {
    if (index < c.questions.length - 1) {
      setState(() {
        index++;
        selected = null;
      });
      return;
    }

    if (finishing) return;
    setState(() => finishing = true);

    final currentLesson = lesson;
    if (currentLesson != null) {
      // Do not block navigation on this endpoint. Some API failures made the
      // Finish button look broken because Get.back() was never reached.
      c.completeLesson(currentLesson.id).catchError((_) {});
    }

    if (mounted) {
      Get.back(result: true);
    }
  }
}

class _QuestionMedia extends StatelessWidget {
  const _QuestionMedia({required this.media});

  final MediaModel media;

  bool get _isImage {
    final mime = (media.mimeType ?? '').toLowerCase();
    final url = (media.absoluteUrl ?? '').toLowerCase();
    return mime.startsWith('image/') ||
        url.endsWith('.png') ||
        url.endsWith('.jpg') ||
        url.endsWith('.jpeg') ||
        url.endsWith('.webp') ||
        url.endsWith('.gif');
  }

  bool get _isAudio {
    final mime = (media.mimeType ?? '').toLowerCase();
    final url = (media.absoluteUrl ?? '').toLowerCase();
    return mime.startsWith('audio/') ||
        url.endsWith('.mp3') ||
        url.endsWith('.wav') ||
        url.endsWith('.m4a');
  }

  @override
  Widget build(BuildContext context) {
    final url = media.absoluteUrl;
    if (url == null) return const SizedBox.shrink();

    if (_isImage) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: CachedNetworkImage(
            imageUrl: url,
            height: 140,
            width: double.infinity,
            fit: BoxFit.cover,
            errorWidget: (context, error, stackTrace) => _MediaTile(
              icon: Icons.broken_image_rounded,
              label: media.filename ?? 'Image unavailable',
            ),
          ),
        ),
      );
    }

    if (_isAudio) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _MediaTile(
          icon: Icons.volume_up_rounded,
          label: media.filename ?? 'Audio prompt',
          subtitle: 'Audio file attached',
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _MediaTile(
        icon: Icons.attach_file_rounded,
        label: media.filename ?? 'Media attachment',
      ),
    );
  }
}

class _MediaTile extends StatelessWidget {
  const _MediaTile({required this.icon, required this.label, this.subtitle});

  final IconData icon;
  final String label;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.sand,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.palm,
            foregroundColor: Colors.white,
            child: Icon(icon),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                if (subtitle != null)
                  Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
