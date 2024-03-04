import '../index.dart';

class AwaitExpressionVisitor extends RecursiveAstVisitor<void> {
  AwaitExpressionVisitor({
    required this.onVisitAwaitExpression,
  });
  void Function(AwaitExpression node) onVisitAwaitExpression;

  @override
  void visitAwaitExpression(AwaitExpression node) {
    onVisitAwaitExpression(node);

    node.visitChildren(this);
  }
}
