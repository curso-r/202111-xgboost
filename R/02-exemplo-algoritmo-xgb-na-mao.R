x <- runif(100, -1, 1)
y <- sin(x*3) + rnorm(100, sd = 0.1)

tibble(x = x, y = y) %>%
  ggplot(aes(x = x, y = y)) +
  geom_point()

loss <- function(y, y_hat) {
  (y - y_hat)^2
}

# gradiente (G)
G <- function(y, y_hat) {
  - 2 * (y - y_hat)
}

# hessiana (H)
H <- function(y, y_hat) {
  2
}

tibble(x = x, y = y) %>%
  mutate(
    errinho_individual = loss(y, 0.5),
    G = G(y, 0.5),
    H = H(y, 0.5)
  )

# f(x) = a + b*x
# f(x, arvores) = 0.0 + lr * arvore1 + lr * arvore2 + ... + lr * arvoreN
f <- function(x, arvores) {
  r <- rep(0, length(x))

  # soma as árvores (os case_whens)
  for (arvore in arvores) {
    r <- r + lr * predict(arvore, tibble(x = x))
  }
  r
}

arvores <- list()
y_hat <- 0.5
lr <- 0.1
trees <- 100
lambda = 0
gamma = 40
tree_depth = 3
for (i in 1:trees) {
  r <- -G(y, y_hat)/H(y, y_hat) # output = - G/H
  arvores[[i]] <- tree::tree(r ~ x)
  y_hat <- f(x, arvores)
}

tibble(x = x, y = y, y_hat = y_hat) %>%
  ggplot() +
  geom_point(aes(x = x, y = y)) +
  geom_step(aes(x = x, y = y_hat), colour = "red", size = 1)
