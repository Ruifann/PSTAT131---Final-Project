```{r}
#Since each of the factors evaluate the condtion of the exterior material and heating conditon, we can convert the factors to numerical value.
train_data$exter_cond <- as.numeric(factor(train_data$exter_cond, 
                                           levels = c("Ex", "Fa","Gd", "TA","Po"),
                                           labels = c(5,2,4,3,1) ,ordered = TRUE))
train_data$heating_qc <- as.numeric(factor(train_data$heating_qc, 
                                           levels = c("Ex", "Fa","Gd", "TA","Po"),
                                           labels = c(5,2,4,3,1) ,ordered = TRUE))
```


```{r}
new_select_data <- train_data %>%
  select(overall_qual, overall_cond, year_built, gr_liv_area, fireplaces, garage_area, central_air, heating_qc, exter_cond, sale_price)
head(new_select_data)
```

```{r}
set.seed(131)
new_split <- initial_split(new_select_data, prop =0.8, strata = "sale_price")

new_train <- training(new_split)
new_test <- testing(new_split)

new_fold <- vfold_cv(new_train, v = 5, strata = "sale_price")
```

Here is a new recipe that we will use in the classification tree model.
```{r}
price_recipe <- recipe(sale_price~ overall_qual + overall_cond + year_built + gr_liv_area  + fireplaces + garage_area + central_air + heating_qc + exter_cond, data = new_train)  %>%
  step_dummy(all_nominal_predictors()) %>%
  step_normalize(all_predictors())
```

```{r}
class.tree <- rpart(sale_price~ overall_qual + overall_cond + year_built + gr_liv_area  + fireplaces + garage_area + central_air + heating_qc + exter_cond,
                    data = new_train, control = rpart.control(cp = 0.01))

plotcp(class.tree)
printcp(class.tree)
```