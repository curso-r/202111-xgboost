library(tidymodels)
library(tidyverse)
library(tidypredict)
library(xgboost)
library(DiagrammeR)

# dados ----------------------------------------------------
data <- tribble(
  ~dose, ~eficacia,
  2, -6,
  8, 4,
  12, 5,
  16, -5
)

# especificacao do modelo ---------------------------------
# mapa dos hiperparâmetros:
#
# tree_depth = tree_depth
# loss_reduction = gamma
# trees = trees
# learn_rate = eta

xgb_model <- boost_tree(
  mtry = 1,
  sample_size = 1,
  min_n = 1,
  loss_reduction = 0,
  learn_rate = 0.3,
  tree_depth = 2,
  trees = 2
) %>%
  set_engine("xgboost", lambda = 0) %>%
  set_mode("regression")

xgb_fit <- fit(xgb_model, eficacia ~ dose, data = data)
xgb_fit

data %>% mutate(
  pred = predict(xgb_fit, data)$.pred
)

xgb.plot.tree(model=xgb_fit$fit)



# bonus: SQL ------------------------------------
con <- DBI::dbConnect(RSQLite::SQLite(), "meu_sqlite_db.db")
tidypredict_sql(xgb_fit$fit, con)

copy_to(con, data, "data", overwrite = TRUE)
DBI::dbListTables(con)

data_sql <- tbl(con, "data") %>%
  mutate(
    pred = !!tidypredict_sql(xgb_fit$fit, con)
  )

# resultado
data_sql

# SQL por trás dos panos
show_query(data_sql)

f(dose = 8) = 0.0 + (1.20000005) + (0.840000033) + 0.5
f(dose = 8) = -10 + 3 *8

