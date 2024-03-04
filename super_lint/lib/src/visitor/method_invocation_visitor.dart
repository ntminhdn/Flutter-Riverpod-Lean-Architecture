import '../index.dart';

class MethodInvocationVisitor extends RecursiveAstVisitor<void> {
  MethodInvocationVisitor({
    required this.onVisitMethodInvocation,
  });
  void Function(MethodInvocation node) onVisitMethodInvocation;

  @override
  void visitMethodInvocation(MethodInvocation node) {
    onVisitMethodInvocation(node);

    // Recursively visit nested MethodInvocation nodes
    node.visitChildren(this);
  }
}
