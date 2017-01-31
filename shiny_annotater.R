# borrowed and edited from https://www.kaggle.com/delemeator/the-nature-conservancy-fisheries-monitoring/marking-heads-and-tails

library(shiny)
library(imager)
library(data.table)

folder <- 'data/train'
print(list.files(folder))
tmp <- lapply(list.files(folder), function(x) list.files(paste0(folder, '/', x)))
files <- data.table(label = rep(list.files(folder), sapply(tmp, length)),
					filename = unlist(tmp))
files <- files[label != 'test_stg1']
n <- nrow(files)

#Choose one:
# 1: new file
# markers <- data.table(image = rep(NA,n),
# 					  head_x = rep(NA,n),
# 					  head_y = rep(NA,n),
# 					  tail_x = rep(NA,n),
# 					  tail_y = rep(NA,n))

# 2: load file
markers <- fread('data/markers.csv')

ui <- bootstrapPage(
	plotOutput('image',
			   click = 'click',
			   width = '900px',
			   height = '600px'
	),
	actionButton('save', 'save'),
	actionButton('clear', 'clear'),
	actionButton('back', 'back'),
	actionButton('go', 'go'),
	numericInput('row', 'go to image', 1)
)

server <- function(input, output) {
	obj <- reactiveValues(
		heads_x = c(),
		heads_y = c(),
		tails_x = c(),
		tails_y = c(),
		i = 1,
		img = NULL
	)
	
	observeEvent(input$go, {obj$i <- input$row})

	observe({
		img <- files[obj$i, filename]
		obj$img = load.image(paste(folder, files[obj$i, label], img, sep = '/'))
		my <- markers[filename == img]
		obj$heads_x <- my[, head_x]
		obj$heads_y <- my[, head_y]
		obj$tails_x <- my[, tail_x]
		obj$tails_y <- my[, tail_y]
	})
	
	observeEvent(input$click, {
		if (length(obj$heads_x) == length(obj$tails_y)) {
			obj$heads_x <- c(obj$heads_x, input$click$x)
			obj$heads_y <- c(obj$heads_y, input$click$y)
		} else {
			obj$tails_x <- c(obj$tails_x, input$click$x)
			obj$tails_y <- c(obj$tails_y, input$click$y)
		}
	})
	
	observeEvent(input$save, {
		if (length(obj$heads_x) > 0) {
			img = files[obj$i, filename]
			markers <<- rbind(markers[filename != img],
							  data.table(filename = img,
							  		   head_x = round(obj$heads_x,1),
							  		   head_y = round(obj$heads_y,1),
							  		   tail_x = round(obj$tails_x,1),
							  		   tail_y = round(obj$tails_y,1)),
							  fill = TRUE)
			# save file after every time save is clicked
			write.table(markers, 'data/markers.csv', 
						quote = FALSE, sep = ',', row.names = FALSE)
		}
		obj$i <- obj$i + 1
	})
	
	observeEvent(input$back, {
		obj$i <- obj$i - 1
	})
	
	observeEvent(input$clear, {
		obj$heads_x <- obj$heads_y <- obj$tails_x <- obj$tails_y <- c()
	})
	
	output$image <- renderPlot({
		lab <- files[obj$i, label]
		img <- files[obj$i, filename]
		plot(obj$img)
		title(paste(lab, img, 'id = ',obj$i))
		points(obj$heads_x, obj$heads_y, col = 'blue', lwd = 3, pch = 16)
		points(obj$tails_x, obj$tails_y, col = 'red', lwd = 3, pch = 16)
	})
}

#run this!
shinyApp(ui = ui, server = server)
