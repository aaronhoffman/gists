public static void OnPropertyChanged<T>(
    this INotifyPropertyChanged @this,
    PropertyChangedEventHandler propertyChanged,
    Expression<Func<T>> propertyExpr)
{
    if (propertyChanged == null) return;

    var memberExpr = (MemberExpression)propertyExpr.Body;
    var ea = new PropertyChangedEventArgs(memberExpr.Member.Name);

    propertyChanged(@this, ea);
}