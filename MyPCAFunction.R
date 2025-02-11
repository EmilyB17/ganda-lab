# function author: emily bean

## FUNCTION: PCA 
# This function performs principal component analysis, prints eigenvalues,
# creates diagnostic plots of variable cos2 and contributions, and 
# finally makes a PCA and biplot with grouping variables and correlations

myPCA <- function(dat) # data for PCA (continuous variables only)
  {
  
  # make the PCA
  pca <- PCA(dat, 
             scale.unit = TRUE, # scale everything to equal variance
             graph = FALSE) # don't print a graph
  
  # get eigenvalues
  eig.val <- get_eigenvalue(pca) 
  
  # print to sdout
  cat("\n printing top eigenvalues... \n\n")
  print(head(eig.val))
  
  # create scree plot
  # this is used to determine the number of PCs to keep
  scree <- fviz_eig(pca, addlabels = TRUE) # look for the "elbow" where added PCs don't contribute much
  
  # get results of PCA
  var <- get_pca_var(pca)
  
  # plot top 20 cos2
  cos2plot <- fviz_cos2(pca, choice = "var", axes = 1:2, top = 20) 
  
  # plot cos2 correlations
  cos2cor <- fviz_pca_var(pca, col.var = "cos2", 
               gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
               repel = TRUE, select.var = list(cos2 = 10)) # get top 10
  
  # plot contributions
  contplot <- fviz_contrib(pca, choice = "var", axes = 1:2, top = 20)
  
  # plot contribution correlations
  contcor <- fviz_pca_var(pca, col.var = "contrib", 
               gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
               repel = TRUE, select.var = list(contrib = 10))
  
  
  return(list(scree, 
              cos2plot, 
              cos2cor,
              contplot,
              contcor))

}

# SECOND FUNCTION: create plots with grouping variables
# the first plot is the PCA with 95% confidence intervals
# the second plot is a biplot

plotPCAs <- function(dat, # data to perform PCA
                     grouping, # grouping variable (independent variable)
                     groupname)  { # the group name as it should appear on a legend title
  
  # make the PCA
  pca <- PCA(dat, 
             scale.unit = TRUE, # scale everything to equal variance
             graph = FALSE) # don't print a graph

  
  ## make grouping plot
  ## color by grouping variables
  groups <- fviz_pca_ind(pca,
                         geom.ind = "point",
                         col.ind = grouping,
                         addEllipses = TRUE,
                         legend.title = groupname,
                         mean.point = FALSE,
                         ellipse.type = "confidence",
                         ellipse.level = 0.95,
                         title = "Principal Component Analysis",
                         subtitle = "Aqueous metabolites"
  )
  
  ## make grouping biplot
  biplot <- fviz_pca_biplot(pca,
                            col.in = grouping,
                            legend.title = groupname,
                            geom.ind = "point",
                            addEllipses = TRUE,
                            select.var = list(contrib = 10),
                            col.var = "black",
                            repel = TRUE,
                            # x and y axis labels with variance
                            xlab = paste0("PCA1 (", round(pca$eig[1, 2], 0), "%)"),
                            ylab = paste0("PCA2 (", round(pca$eig[2, 2], 0), "%)"),
                            title = "Principal Components Analysis Biplot")
  
  return(list(groups, biplot))
}

