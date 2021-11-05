# fonte: https://hfshr.netlify.app/posts/2020-06-07-variable-inportance-with-fastshap/
library(tidymodels)
data("credit_data")

credit_data <- credit_data %>%
  drop_na()

set.seed(12)

# initial split
split <- initial_split(credit_data, prop = 0.75, strata = "Status")

# train/test sets
train <- training(split)
test <- testing(split)

rec <- recipe(Status ~ ., data = train) %>%
  step_bagimpute(Home, Marital, Job, Income, Assets, Debt) %>%
  step_dummy(Home, Marital, Records, Job, one_hot = T)

# Just some sensible values, not optimised by any means!
mod <- boost_tree(trees = 500,
                  mtry = 6,
                  min_n = 10,
                  tree_depth = 5) %>%
  set_engine("xgboost") %>%
  set_mode("classification")

xgboost_wflow <- workflow() %>%
  add_recipe(rec) %>%
  add_model(mod) %>%
  fit(train)

xg_res <- last_fit(xgboost_wflow,
                   split,
                   metrics = metric_set(roc_auc, pr_auc, accuracy))

xg_res %>% collect_metrics()

preds <- xg_res %>% collect_predictions()


# importance ----------------------------
library(vip)

# Get our model object
xg_mod <- pull_workflow_fit(xgboost_wflow)

vip(xg_mod$fit)


# shap -----------------------------------
library(fastshap)

# Apply the preprocessing steps with prep and juice to the training data
X <- prep(rec, train) %>%
  juice() %>%
  select(-Status) %>%
  as.matrix()

# Compute shapley values
shap <- fastshap::explain(xg_mod$fit, X = X, exact = TRUE)

# Create a dataframe of our training data
feat <- prep(rec, train) %>%
  juice()

autoplot(shap,
         type = "dependence",
         feature = "Amount",
         X = feat,
         smooth = TRUE,
         color_by = "Status")

# contribution ---------------
library(patchwork)
p1 <- autoplot(shap, type = "contribution", row_num = 1541) +
  ggtitle("Likely bad")

p2 <- autoplot(shap, type = "contribution", row_num = 1806) +
  ggtitle("Likely good")

p1+p2

# force plot ----------------
force_plot(object = shap[1541,],
           feature_values = X[1541,],
           display = "html",
           link = "logit")

force_plot(object = shap[1806,],
           feature_values = X[1806,],
           display = "html",
           link = "logit")

force_plot(object = shap[c(1:50),],
           feature_values = X[c(1:50),],
           display = "html",
           link = "logit")
