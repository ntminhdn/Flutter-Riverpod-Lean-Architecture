import '../index.dart';

class ReturnStatementVisitor extends RecursiveAstVisitor<void> {
  ReturnStatementVisitor({
    required this.onVisitReturnStatement,
  });
  void Function(ReturnStatement node) onVisitReturnStatement;

  @override
  void visitReturnStatement(ReturnStatement node) {
    onVisitReturnStatement(node);

    node.visitChildren(this);
  }
}
