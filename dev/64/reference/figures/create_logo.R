library(xml2)

hex_corners <- function(height = 384, width = 332.16) {
  width1 <- width/2
  height1 <- height / 4 * 3
  height2 <- height / 4

  list(
    top = c(x = width1, y = 0),
    ur = c(x = width, y = height2),
    br = c(x = width, y = height1),
    bot = c(x = width1, y = height),
    bl = c(x = 0, y = height1),
    ul = c(x = 0, y = height2)
  )
}

hex_points <- function(hex_points = hex_corners()) {
  points <- lapply(hex_points, \(x) paste(x, collapse = ","))
  paste(points, collapse = " ")
}

create_stripes <- function(.x, angle = "45", line.width = "10", cols = c("red", "blue")) {
  n_cols <- length(cols)
  pattern <- xml_add_child(
    .x, "pattern",
    id=paste0("stripes", angle),
    patternUnits="userSpaceOnUse",
    width=as.character(as.numeric(line.width) * n_cols),
    height="200",
    patternTransform=paste0("rotate(", angle, ")")
  )
  lapply(1:n_cols, \(i) {
    xml_add_child(
      pattern, "rect",
      x=as.character(as.numeric(line.width) * (i-1)),
      width=line.width, height="200", fill=cols[i]
    )
    return(invisible())
  })

  return(invisible())
}

add_striped_hexagon <- function(.x, height = "384", width = "332.16",
                                fill = "#ccc", border.line.width = "10",
                                border.width = NULL, border.opacity = "0.2",
                                border.cols = c("red", "blue")) {

  if (is.null(border.width)) border.width = as.character(as.numeric(height) / 40)

  defs <- xml_add_child(.x, "defs")
  create_stripes(defs, angle = 30, line.width = border.line.width, cols = border.cols)
  create_stripes(defs, angle = 90, line.width = border.line.width, cols = border.cols)
  create_stripes(defs, angle = 150, line.width = border.line.width, cols = border.cols)
  create_stripes(defs, angle = 210, line.width = border.line.width, cols = border.cols)
  create_stripes(defs, angle = 270, line.width = border.line.width, cols = border.cols)
  create_stripes(defs, angle = 330, line.width = border.line.width, cols = border.cols)

  hexc <- hex_corners(height = as.numeric(height), width = as.numeric(width))
  pts <- lapply(hexc, \(pt) paste(pt, collapse = ","))
  pts$mid <- paste0(as.numeric(width) / 2, ",", as.numeric(height) / 2)
  xml_add_child(
    .x, "polygon",
    points = paste(pts[c("top", "ur", "mid")], collapse = " "),
    fill = "url(#stripes30)", opacity = border.opacity
  )
  xml_add_child(
    .x, "polygon",
    points = paste(pts[c("ur", "br", "mid")], collapse = " "),
    fill = "url(#stripes90)", opacity = border.opacity
  )
  xml_add_child(
    .x, "polygon",
    points = paste(pts[c("br", "bot", "mid")], collapse = " "),
    fill = "url(#stripes150)", opacity = border.opacity
  )
  xml_add_child(
    .x, "polygon",
    points = paste(pts[c("bot", "bl", "mid")], collapse = " "),
    fill = "url(#stripes210)", opacity = border.opacity
  )
  xml_add_child(
    .x, "polygon",
    points = paste(pts[c("bl", "ul", "mid")], collapse = " "),
    fill = "url(#stripes270)", opacity = border.opacity
  )
  xml_add_child(
    .x, "polygon",
    points = paste(pts[c("ul", "top", "mid")], collapse = " "),
    fill = "url(#stripes330)", opacity = border.opacity
  )

  num_bor <- as.numeric(border.width)
  small_hex <- hex_corners(height = as.numeric(height) - num_bor, width = as.numeric(width) - num_bor)
  inside_hex <- lapply(small_hex, \(pt) pt + num_bor / 2)
  xml_add_child(
    .x, "polygon",
    points=hex_points(inside_hex),
    fill = fill
  )

  return(invisible())
}

create_arc <- function(r, x, y) {
  paste0("A ", r, " ", r, " 0 0 0 ", x, " ", y)
}
create_line_to <- function(x, y) {
  paste0("L ", x, " ", y)
}
is.arc <- function(str) {
  grepl("^A", str)
}
is.line <- function(str) {
  grepl("^L", str)
}

create_stamp_edge <- function(coords) {

  x_varies <- length(unique(coords$x)) > 1
  vary_var <- ifelse(x_varies, "x", "y")
  novary_var <- ifelse(x_varies, "y", "x")

  num_arc <- abs(coords[[vary_var]][2] - coords[[vary_var]][1])
  num_lin <- abs(coords[[vary_var]][3] - coords[[vary_var]][2])
  r <- num_arc / 2

  path <- vector("list")

  n_coords <- length(coords[[vary_var]])

  for (i in 1:n_coords) {
    even <- i %% 2 == 0
    if (!even) {
      path[i] <- create_line_to(x = coords$x[i], y = coords$y[i])
    } else {
      path[i] <- create_arc(r = r, x = coords$x[i], y = coords$y[i])
    }
  }

  end_line <- is.line(path[n_coords])
  last_vary_val <- coords[[vary_var]][n_coords]

  novary_val <- unique(coords[[novary_var]])
  if (novary_val == 0) novary_end <- r
  else novary_end <- novary_val - r

  vary_inc <- all(sort(coords[[vary_var]]) == coords[[vary_var]])

  if (end_line) {
    viewBoxEnd <- last_vary_val + ifelse(vary_inc, r, -r)

    arc_args <- setNames(
      list(r, viewBoxEnd, novary_end),
      c("r", vary_var, novary_var)
    )
    end_arc <- do.call(create_arc, arc_args)
    path <- c(path, list(end_arc))
  } else {
    viewBoxEnd <- last_vary_val + ifelse(vary_inc, num_lin + r, - num_lin - r)

    line_args <- setNames(
      list(last_vary_val + ifelse(vary_inc, num_lin, -num_lin), novary_val),
      c(vary_var, novary_var)
    )
    arc_args <- setNames(
      list(r, viewBoxEnd, novary_end),
      c("r", vary_var, novary_var)
    )
    path <- c(path, list(
      do.call(create_line_to, line_args),
      do.call(create_arc, arc_args))
    )
  }

  structure(
    paste(path, collapse = " "),
    viewBoxEnd = viewBoxEnd
  )
}

add_stamp_background <- function(
    .x,
    x = "0", y = "0",
    height = "500", width = "500",
    arc.length = "8", line.length = "5",
    fill = "gray") {

  num_arc <- as.numeric(arc.length)
  num_lin <- as.numeric(line.length)
  r <- num_arc / 2
  path_start <- paste0("M ", r, " 0 ")

  coord_increments <- c(rep(c(num_lin, num_arc), 1e3))
  coord_placements <- cumsum(coord_increments) + r
  coord_placements <- coord_placements[coord_placements <= 100]

  coords_top <- list(x = coord_placements, y = rep(0, length(coord_placements)))
  path_top <- create_stamp_edge(coords = coords_top)
  xend <- attr(path_top, "viewBoxEnd")

  coords_right <- list(y = coord_placements, x = rep(xend, length(coord_placements)))
  path_right <- create_stamp_edge(coords = coords_right)
  yend <- attr(path_right, "viewBoxEnd")

  coords_bot <- list(x = rev(coord_placements)[-1], y = rep(yend, length(coord_placements)))
  path_bot <- create_stamp_edge(coords = coords_bot)

  coords_left <- list(y = rev(coord_placements)[-1], x = rep(0, length(coord_placements)))
  path_left <- create_stamp_edge(coords = coords_left)

  path <- paste0(path_start, path_top, " ", path_right, " ", path_bot, " ", path_left)

  vb <- xml_add_child(
    .x, "svg",
    x = x, y = y,
    height = height, width = width,
    viewBox=paste0("0 0 ", xend, " ", yend)
  )

  xml_add_child(
    vb, "path",
    fill=fill,
    d=path
  )

  return(svg)
}

add_r_logo <- function(.x, x.rect = "410", y.rect = "20", width.rect = "60", height.rect = "60",
                       background.fill = "white") {
  xml_add_child(
    .x, "rect",
    x=x.rect, y=y.rect, width=width.rect, height=height.rect,
    fill=background.fill
  )
  x.logosvg <- as.character(as.numeric(x.rect) + 2.5)
  y.logosvg <- as.character(as.numeric(y.rect) + 2.5)
  width.logosvg <- as.character(as.numeric(width.rect) - 5)
  height.logosvg <- as.character(as.numeric(height.rect) - 5)

  rlogo_svg <- xml_add_child(
    .x, "svg",
    preserveAspectRatio="xMidYMid", x=x.logosvg, y=y.logosvg,
    width=width.logosvg, height=height.logosvg,
    viewBox="0 0 724 561"
  )
  rlogo_defs <- xml_add_child(
    rlogo_svg, "defs")
  rlogo_gradient1 <- xml_add_child(
    rlogo_defs, "linearGradient",
    id="gradientFill-1", x1="0", x2="1", y1="0", y2="1",
    gradientUnits="objectBoundingBox", spreadMethod="pad"
  )
  xml_add_child(
    rlogo_gradient1, "stop",
    offset="0", "stop-color"="rgb(203,206,208)", "stop-opacity"="1"
  )
  xml_add_child(
    rlogo_gradient1, "stop",
    offset="1", "stop-color"="rgb(132,131,139)", "stop-opacity"="1"
  )

  rlogo_gradient2 <- xml_add_child(
    rlogo_defs, "linearGradient",
    id="gradientFill-2", x1="0", x2="1", y1="0", y2="1",
    gradientUnits="objectBoundingBox", spreadMethod="pad"
  )
  xml_add_child(
    rlogo_gradient2, "stop",
    offset="0", "stop-color"="rgb(39,109,195)", "stop-opacity"="1"
  )
  xml_add_child(
    rlogo_gradient2, "stop",
    offset="1", "stop-color"="rgb(22,92,170)", "stop-opacity"="1"
  )
  xml_add_child(
    rlogo_svg, "path",
    d="M361.453,485.937 C162.329,485.937 0.906,377.828 0.906,244.469 C0.906,111.109 162.329,3.000 361.453,3.000 C560.578,3.000 722.000,111.109 722.000,244.469 C722.000,377.828 560.578,485.937 361.453,485.937 ZM416.641,97.406 C265.289,97.406 142.594,171.314 142.594,262.484 C142.594,353.654 265.289,427.562 416.641,427.562 C567.992,427.562 679.687,377.033 679.687,262.484 C679.687,147.971 567.992,97.406 416.641,97.406 Z",
    fill="url(#gradientFill-1)",
    "fill-rule"="evenodd"
  )
  xml_add_child(
    rlogo_svg, "path",
    d="M550.000,377.000 C550.000,377.000 571.822,383.585 584.500,390.000 C588.899,392.226 596.510,396.668 602.000,402.500 C607.378,408.212 610.000,414.000 610.000,414.000 L696.000,559.000 L557.000,559.062 L492.000,437.000 C492.000,437.000 478.690,414.131 470.500,407.500 C463.668,401.969 460.755,400.000 454.000,400.000 C449.298,400.000 420.974,400.000 420.974,400.000 L421.000,558.974 L298.000,559.026 L298.000,152.938 L545.000,152.938 C545.000,152.938 657.500,154.967 657.500,262.000 C657.500,369.033 550.000,377.000 550.000,377.000 ZM496.500,241.024 L422.037,240.976 L422.000,310.026 L496.500,310.002 C496.500,310.002 531.000,309.895 531.000,274.877 C531.000,239.155 496.500,241.024 496.500,241.024 Z",
    fill="url(#gradientFill-2)",
    "fill-rule"="evenodd"
  )

  return(invisible())
}

add_textOnLine <- function(
    .x, text, text_cols = NULL, x="270", y="200", y.offset = "5", line.length = "210", font.size = "14") {

  text_ele <- xml_add_child(
    .x, "text",
    x=x, y=y, "font-size"=font.size, fill="black"
  )
  xml_text(text_ele) <- gsub(names(text_cols), "", text)
  lapply(1:length(text_cols), \(i)
         xml_add_child(text_ele, "tspan", names(text_cols)[i], fill=text_cols[i]))

  y_line <- as.character(as.numeric(y) + as.numeric(y.offset))
  xml_add_child(
    .x, "line",
    x1=x, y1=y_line,
    x2=as.character(as.numeric(x) + as.numeric(line.length)), y2=y_line,
    stroke="black", "stroke-width"="0.5"
  )

  return(invisible())
}

add_man <- function(
    .x, cx.head = "50", cy.head = "35", r.head = "12", r.body = "20", fill = "rgb(79, 183, 227)") {
  xml_add_child(
    .x, "circle",
    cx=cx.head, cy=cy.head, r=r.head, fill=fill
  )
  r.body <- as.character(as.numeric(r.head) * 5/3)
  xstart.body <- as.character(as.numeric(cx.head) - as.numeric(r.body))
  xend.body <- as.character(as.numeric(cx.head) + as.numeric(r.body))
  y.body <- as.character(as.numeric(cy.head) + as.numeric(r.body) + as.numeric(r.head))
  xml_add_child(
    .x, "path",
    d = paste0("M ", xstart.body, " ", y.body, " A ", r.body, " ", r.body, " 0 0 1 ",
               xend.body, " ", y.body, " L ", xstart.body, " ", y.body, " Z"),
    fill = fill
  )

  return(invisible())
}

create_hex_logo <- function(height = "278", width = "240",
                            background.fill = "#ccc",
                            border.line.width = "10", border.width = NULL, border.opacity = "0.2",
                            border.cols = c("red", "blue"),
                            rlogo.fill = "white", stamp.fill = "#C1C7C9",
                            topman.fill = "gray", botman.fill = "rgb(79, 183, 227)") {
  svg <- xml_new_root("svg",
                      version="1.1",
                      width=width, height=height,
                      xmlns="http://www.w3.org/2000/svg")

  # svg <- xml_add_child(
  #   res, "svg",
  #   height=height, width=width,
  #   viewBox="0 0 100 100",
  #   preserveAspectRatio="none"
  # )

  add_striped_hexagon(
    svg,
    width = width, height = height,
    fill = background.fill,
    border.line.width = border.line.width, border.width = border.width, border.opacity = border.opacity,
    border.cols = border.cols
    )
  # Add line in the middle
  xml_add_child(
    svg, "line",
    x1="50%", y1="38%", x2="50%", y2="90%", stroke="black", "stroke-width"="0.5"
  )

  # Add a stamp with the R logo
  add_stamp_background(svg, x = "200", y = "110", width = "30", height = "30", fill = stamp.fill)
  add_r_logo(svg, x.rect = "203", y.rect = "113", width.rect = "24", height.rect = "24",
             background.fill = rlogo.fill)
  # Add a title
  xml_add_child(
    svg, "text", "postcard",
    x="50%", y="33%", "font-family"="monospace", "font-size"="40", fill="black",
    "text-anchor"="middle"
  )
  # Add some text on lines
  add_textOnLine(
    svg, "From: Historical data",
    text_cols = c("Historical data" = topman.fill),
    x="130", y="165", y.offset = "4", line.length = "100", font.size = "11")
  add_textOnLine(
    svg, "To: New RCT",
    text_cols = c("New RCT" = botman.fill),
    x="130", y="190", y.offset = "4", line.length = "100", font.size = "11")

  add_man(svg, cx.head = "30", cy.head = "150", r.head="6", fill = topman.fill)
  add_man(svg, cx.head = "52.5", cy.head = "150", r.head="6", fill = topman.fill)
  add_man(svg, cx.head = "75", cy.head = "150", r.head="6", fill = topman.fill)
  add_man(svg, cx.head = "97.5", cy.head = "150", r.head="6", fill = topman.fill)
  add_man(svg, cx.head = "41.25", cy.head = "125", r.head="6", fill = topman.fill)
  add_man(svg, cx.head = "63.75", cy.head = "125", r.head="6", fill = topman.fill)
  add_man(svg, cx.head = "87.25", cy.head = "125", r.head="6", fill = topman.fill)

  add_man(svg, cx.head = "33.75", cy.head = "185", fill = botman.fill, r.head = "8")
  add_man(svg, cx.head = "63.75", cy.head = "185", fill = botman.fill, r.head = "8")
  add_man(svg, cx.head = "93.75", cy.head = "185", fill = botman.fill, r.head = "8")

  return(svg)
}

svg_logo <- create_hex_logo(
  background.fill = "#f1f2ec",
  border.opacity = "0.5",
  border.line.width = "5",
  border.cols = c("blue", "yellow", "red"),
  stamp.fill = "green")

write_xml(svg_logo, "man/figures/logo.svg")
rsvg::rsvg_png("man/figures/logo.svg", "man/figures/logo.png")
