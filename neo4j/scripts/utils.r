
is.wholenumber <- function(x, tol = 1e-100)
{
	if(all(is.numeric(x) | is.integer(x), na.rm=TRUE) )
	{
		if(all(abs(x - round(x)) < tol, na.rm=TRUE))
		{
			return(TRUE)
		} else {
			return(FALSE)
		}
	}
	return(FALSE)
}

modify_node_headers_for_neo4j <- function(x, id, idname)
{
	id_col <- which(names(x) == id)
	cl <- sapply(x, class)
	for(i in 1:length(cl))
	{
		if(cl[i] == "integer")
		{
			names(x)[i] <- paste0(names(x)[i], ":INT")
		}
		if(cl[i] == "numeric")
		{
			if(is.wholenumber(x[,i]))
			{
				names(x)[i] <- paste0(names(x)[i], ":INT")
			} else {
				names(x)[i] <- paste0(names(x)[i], ":FLOAT")
			}
		}
	}
	names(x)[id_col] <- paste0(idname, "Id:ID(", idname, ")")
	return(names(x))
}

modify_rel_headers_for_neo4j <- function(x, id1, id1name, id2, id2name)
{
	id1_col <- which(names(x) == id1)
	id2_col <- which(names(x) == id2)
	cl <- sapply(x, class)

	for(i in 1:length(cl))
	{

		if(cl[i] == "integer")
		{
			names(x)[i] <- paste0(names(x)[i], ":INT")
		}
		if(cl[i] == "numeric")
		{
			if(is.wholenumber(x[,i]))
			{
				names(x)[i] <- paste0(names(x)[i], ":INT")
			} else {
				names(x)[i] <- paste0(names(x)[i], ":FLOAT")
			}
		}
	}
	names(x)[id1_col] <- paste0(":START_ID(", id1name, ")")
	names(x)[id2_col] <- paste0(":END_ID(", id2name, ")")
	return(names(x))
}


write_out <- function(x, basename, header=FALSE)
{
	g <- gzfile(paste0(basename, ".csv.gz"), "w")
	write.table(x, g, row.names=FALSE, col.names=FALSE, na="", sep=",")
	close(g)
	if(header) write.table(x[0,], file=paste0(basename, "_header.csv"), row.names=FALSE, col.names=TRUE, sep=",")
}


