```{r}
tree_spec <- decision_tree() %>%
  set_engine("rpart")

reg_tree_spec <- tree_spec %>%
  set_mode("regression")

reg_tree_fit <- fit(reg_tree_spec, 
                    sale_price~ overall_qual + overall_cond + year_built + gr_liv_area  + fireplaces + garage_area + central_air + heating_qc + exter_cond, new_train)

augment(reg_tree_fit, new_data = new_test) %>%
  rmse(truth = sale_price, estimate = .pred)
```

```{r}
reg_tree_fit %>%
  extract_fit_engine() %>%
  rpart.plot()
```

```{r}
reg_tree_wf <- workflow() %>%
  add_model(reg_tree_spec %>% set_args(cost_complexity = tune())) %>%
  add_formula(sale_price~ overall_qual + overall_cond + year_built + gr_liv_area  + fireplaces)

set.seed(3435)
reg_fold <- vfold_cv(new_train)

param_grid <- grid_regular(cost_complexity(range = c(-4, -1)), levels = 5)

tune_res <- tune_grid(
  reg_tree_wf, 
  resamples = reg_fold, 
  grid = param_grid
)
```

```{r}
autoplot(tune_res)
```

```{r}
best_complexity <- select_best(tune_res, metric = "rmse")

reg_tree_final <- finalize_workflow(reg_tree_wf, best_complexity)

reg_tree_final_fit <- fit(reg_tree_final, data = new_train)
```

```{r}
reg_tree_final_fit %>%
  extract_fit_engine() %>%
  rpart.plot()
```