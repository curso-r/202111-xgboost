library(tidymodels)
library(tidypredict)

# dados ----------------------------------------------------
data <- tribble(
  ~dose, ~curou,
  2,    "não curou",
  8,    "curou",
  12,   "curou",
  16,   "não curou"
) 

# receita -------------------------------------------------
# a receita define as seguintes partes:
# 1) a variável resposta
# 2) as variáveis explicativas
# 3) as transformações do dataprep
# Veremos com detalhe na Aula 3.
xgb_rec <- recipe(curou ~ dose, data = data) %>%
  step_zv(all_numeric_predictors())

# especificacao do modelo ---------------------------------
# mapa dos hiperparâmetros:
#
# tree_depth = tree_depth
# loss_reduction = gamma
# lambda = lambda
# learn_rate = eta

# Exercício 1 ##################################################################
# não queremos "regression" mais, queremos "classification"

xgb_model <- boost_tree(
  mode = "classification",
  mtry = 1,
  sample_size = 1,
  min_n = 1,

  # -----------------------------------
  loss_reduction = 0,
  learn_rate = 0.3,
  tree_depth = 2,
  trees = 2

  #-------------------------------------
) %>%
  set_engine("xgboost", lambda = 0, params = list(min_child_weight = 0, objective = "binary:logistic"))

xgb_wf <- workflow() %>%
  add_model(xgb_model) %>%
  add_recipe(xgb_rec)

# fit (para resolver os exercícios 2 e 3)
xgb_fit <- fit(xgb_wf, data = data)
xgb_fit

# Exercício 2 ##################################################################
# Repare no parâmetro 'params = list(min_child_weight = 0)'.
# visite https://xgboost.readthedocs.io/en/latest/parameter.html
# para consultar a documentação da função xgboost e procure pela definição de min_child_weight.


# Exercício 3 ##################################################################
# Observe essa tabela gerada pelo código abaixo. O parâmetro  type = "prob" faz 
# com que o predict devolva uma tabela com as predições de cada categoria da 
# variável resposta.Remova esse parâmetro type e rode novamente para ver o que 
# ele devolve.
predict(xgb_fit, data, type = "prob")

# tabela com as predições
predict(xgb_fit, data, type = "prob")

data %>% mutate(
  pred = predict(xgb_fit, ., type = "prob")$.pred_curou
)

# Gere a probabilidade para o banco de dados 'dado_novo' de uma linha.
dado_novo <- data.frame(dose = 7)

# RESULTADO ESPERADO ########################
# # A tibble: 1 × 2
#     .pred_curou  `.pred_não curou`
#           <dbl>             <dbl>
#   1       0.744             0.256




