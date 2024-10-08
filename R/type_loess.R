#' LOESS type
#' 
#' @inheritParams stats::loess
#' @importFrom stats loess loess.control predict
#' @export
type_loess = function(
    span = 0.75,
    degree = 2,
    family = "gaussian",
    control = loess.control()) {
    out = list(
        draw = draw_lines(),
        data = data_loess(span = span, degree = degree, family = family, control = control),
        name = "l"
    )
    class(out) = "tinyplot_type"
    return(out)
}


data_loess = function(span, degree, family, control, ...) {
    fun = function(datapoints, ...) {
        dat = split(datapoints, list(datapoints$facet, datapoints$by))
        dat = lapply(dat, function(x) {
            fit = loess(y ~ x, data = x, span = span, degree = degree, family = family, control = control)
            x$y = predict(fit, x)
            x
        })
        datapoints = do.call(rbind, dat)
        datapoints = datapoints[order(datapoints$facet, datapoints$by, datapoints$x), ]
        out = list(datapoints = datapoints)
        return(out)
    }
    return(fun)
}

