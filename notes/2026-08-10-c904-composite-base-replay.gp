\\ Independent PARI/GP replay for the composite quadratic-cover arithmetic.
E = ellinit([1, -1, 0, 333, -7259]);
print("Independent PARI/GP arithmetic replay");
print("ellrank=", ellrank(E));
print("elltors=", elltors(E));
print("conductor=", ellglobalred(E)[1]);
quit;
