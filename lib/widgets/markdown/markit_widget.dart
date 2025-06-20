import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import './widgets/latex.dart';
import './widgets/link.dart';
import './widgets/code.dart';
import './widgets/details.dart';
import 'widgets/think.dart';
import './widgets/artifact.dart';
import './widgets/image.dart';
import './widgets/inline_code.dart';
import './widgets/function.dart';
import './widgets/function_result.dart';

class MarkitTestPage extends StatelessWidget {
  const MarkitTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    String testMarkdown = r'''
This image is a math problem, involving the calculation of the cost of anti-slip tiles in a school building. The problem description is as follows:

<think data-name="test1" age="18" start-time="2025-02-07 10:00:00"># test</think status="en">

<think name="test" age="18">
33333
## test
</think closed="true">

<think name="test" age="18">33333

''' '\n${DateTime.now().toIso8601String()}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Markit Test'),
      ),
      body: Markit(data: testMarkdown),
    );
  }
}

class Markit extends StatefulWidget {
  final String data;
  final TextStyle? textStyle;

  const Markit({super.key, required this.data, this.textStyle});

  @override
  State<Markit> createState() => _MarkitState();
}

class _MarkitState extends State<Markit> {
  String _cachedData = '';
  Widget? _cachedMarkdown;
  Brightness? _cachedBrightness;

  @override
  Widget build(BuildContext context) {

    final currentBrightness = Theme.of(context).brightness;
    if (widget.data != _cachedData || _cachedMarkdown == null ||  _cachedBrightness != currentBrightness) {

      _cachedData = widget.data;
      _cachedBrightness = currentBrightness;

      final isDark = currentBrightness == Brightness.dark;
      final textStyle = widget.textStyle;
      final data = _cachedData;
      _cachedMarkdown = MarkdownBlock(
        data: data,
        config: MarkdownConfig(
          configs: [
            PConfig(
                textStyle: textStyle ??
                    const TextStyle(fontSize: 14, height: 20 / 14)),
            H1Config(style: const TextStyle(fontSize: 24, height: 24 / 24)),
            H2Config(style: const TextStyle(fontSize: 20, height: 20 / 20)),
            H3Config(style: const TextStyle(fontSize: 16, height: 16 / 16)),
            H4Config(style: const TextStyle(fontSize: 12, height: 12 / 12)),
            H5Config(style: const TextStyle(fontSize: 14, height: 14 / 14)),
            H6Config(style: const TextStyle(fontSize: 14, height: 14 / 14)),
            TableConfig(),
            CodeConfig(),
            LinkConfig(
              style: const TextStyle(
                color: Colors.yellow,
                decoration: TextDecoration.underline,
              ),
            ),
            isDark
                ? PreConfig.darkConfig
                    .copy(textStyle: const TextStyle(fontSize: 12))
                : PreConfig().copy(textStyle: const TextStyle(fontSize: 12)),
            DetailConfig(),
          ],
        ),
        generator: MarkdownGenerator(
          linesMargin: const EdgeInsets.symmetric(vertical: 4),
          generators: [
            linkGenerator,
            latexGenerator,
            codeBlockGenerator,
            artifactAntThinkingGenerator,
            artifactAntArtifactGenerator,
            thinkGenerator,
            detailsGenerator,
            imageGenerator,
            inlineCodeGenerator,
            functionResultGenerator,
            functionGenerator,
          ],
          inlineSyntaxList: [
            ArtifactAntThinkingInlineSyntax(),
            ArtifactAntArtifactInlineSyntax(),
            DetailsSyntax(),
            LinkSyntax(),
            LatexSyntax(),
            ThinkInlineSyntax(),
            FunctionInlineSyntax(),
            FunctionResultInlineSyntax(),
          ],
          blockSyntaxList: [
            DetailsBlockSyntax(),
            LatexBlockSyntax(),
            ThinkBlockSyntax(),
            ArtifactAntThinkingBlockSyntax(),
            ArtifactAntArtifactBlockSyntax(),
            FunctionBlockSyntax(),
            FunctionResultBlockSyntax(),
            FencedCodeBlockSyntax(),
          ],
        ),
      );
    }
    return _cachedMarkdown ?? const SizedBox();
  }
}
