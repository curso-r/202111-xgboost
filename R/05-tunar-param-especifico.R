library(tidymodels)

library(modeldata)
data("lending_club")

model <- boost_tree(
  mtry = tune(),
  trees = 100,
  min_n = 30,
  tree_depth = 4,
  learn_rate = 0.1,
  loss_reduction = 0,
  sample_size = 0.8
)  %>%
  set_engine("xgboost", lambda = tune("lambda")) %>%
  set_mode("classification")

rec <- recipe(Class ~ ., data = lending_club) %>%
  step_dummy(all_nominal(), -all_outcomes())

pars <- model %>%
  parameters() %>%
  update(
    lambda = dials::penalty(),
    mtry = dials::mtry(range = c(1L, 10L))
  )

grid_de_params <- expand.grid(mtry = c(0.5, 0.8, 0.9), lambda = c(0.1, 0, 1e6))

tun <- tune_grid(
  model,
  preprocessor = rec,
  resamples = vfold_cv(lending_club, 5),
  grid = grid_de_params,
  param_info = pars
)

autoplot(tun)
show_best(tun)
select_best(tun)
