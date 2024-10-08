sanitize_ribbon.alpha = function(ribbon.alpha) {
    assert_numeric(ribbon.alpha, len = 1, lower = 0, upper = 1, null.ok = TRUE)
    if (is.null(ribbon.alpha)) ribbon.alpha = .tpar[["ribbon.alpha"]]
    return(ribbon.alpha)
}



sanitize_type = function(type, x, y) {
    if (inherits(type, "tinyplot_type")) {
        return(type)
    }

    types = c("area", "boxplot", "density", "jitter", "ribbon", "pointrange", "hist", 
        "histogram", "errorbar", "polygon", "polypath", "rect", "segments", "points", 
        "p", "l", "o", "b", "c", "h", "j", "s", "S", "n", "loess", "lm", "glm")
    assert_choice(type, types, null.ok = TRUE)

    if (is.null(type)) {
        # enforce boxplot type for y ~ factor(x)
        if (!is.null(x) && is.factor(x) && !is.factor(y)) {
            return(type_boxplot())
        } else {
            type = "p"
        }
    } else if (type %in% c("hist", "histogram")) {
        type = "histogram"
    } else if (type %in% c("j", "jitter")) {
        type = return(type_jitter())
    }

    type_fun = switch(type,
        "points" = type_points(),
        "segments" = type_segments(),
        "area" = type_area(),
        "rect" = type_rect(),
        "polypath" = type_polypath(),
        "polygon" = type_polygon(),
        "pointrange" = type_pointrange(),
        "errorbar" = type_errorbar(),
        "boxplot" = type_boxplot(),
        "ribbon" = type_ribbon(),
        "histogram" = type_histogram(),
        "j" = type_jitter(),
        "jitter" = type_jitter(),
        "loess" = type_loess(),
        "glm" = type_glm(),
        "lm" = type_lm(),
        NULL  # Default case
    )
    if (inherits(type_fun, "tinyplot_type")) return(type_fun)

    out = list(draw = NULL, data = NULL, name = type)
    return(out)
}
