likes(alice, chocolate).
likes(bob, cheese).
likes(charlie, chocolate).
likes(charlie, cheese).

friend(X, Y) :- likes(X, Z), likes(Y, Z), \+(X = Y).
