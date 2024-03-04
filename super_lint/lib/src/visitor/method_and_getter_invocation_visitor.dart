import '../index.dart';

class MethodAndGetterInvocationVisitor extends RecursiveAstVisitor<void> {
  MethodAndGetterInvocationVisitor({
    required this.onVisitMethodInvocation,
    required this.onPropertyAccessInvocation,
    required this.onVisitPrefixedIdentifier,
    required this.onVisitIndexExpression,
  });
  void Function(MethodInvocation node) onVisitMethodInvocation;
  void Function(PropertyAccess node) onPropertyAccessInvocation;
  void Function(PrefixedIdentifier node) onVisitPrefixedIdentifier;
  void Function(IndexExpression node) onVisitIndexExpression;

  @override
  void visitMethodInvocation(MethodInvocation node) {
    onVisitMethodInvocation(node);

    // Recursively visit nested MethodInvocation nodes
    node.visitChildren(this);
  }

  @override
  void visitPropertyAccess(PropertyAccess node) {
    onPropertyAccessInvocation(node);

    // Recursively visit nested PropertyAccess nodes
    node.visitChildren(this);
  }

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    onVisitPrefixedIdentifier(node);

    // Recursively visit nested PrefixedIdentifier nodes
    node.visitChildren(this);
  }

  @override
  void visitIndexExpression(IndexExpression node) {
    onVisitIndexExpression(node);

    // Recursively visit nested IndexExpression nodes
    node.visitChildren(this);
  }
}
