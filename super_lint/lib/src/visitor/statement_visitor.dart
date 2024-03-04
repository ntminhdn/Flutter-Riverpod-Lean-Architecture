import '../index.dart';

class StatementVisitor extends RecursiveAstVisitor<void> {
  StatementVisitor({
    required this.onVisitExpressionStatement,
    required this.onVisitReturnStatement,
  });
  void Function(ExpressionStatement node) onVisitExpressionStatement;
  void Function(ReturnStatement node) onVisitReturnStatement;

  @override
  void visitExpressionStatement(ExpressionStatement node) {
    onVisitExpressionStatement(node);

    node.visitChildren(this);
  }

  @override
  void visitReturnStatement(ReturnStatement node) {
    onVisitReturnStatement(node);

    node.visitChildren(this);
  }
}
