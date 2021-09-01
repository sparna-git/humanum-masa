package fr.humanum.openarchaeo.federation.repository;

import java.util.Iterator;

import org.apache.jena.sparql.core.TriplePath;
import org.apache.jena.sparql.path.P_NegPropSet;
import org.apache.jena.sparql.path.P_Path0;
import org.apache.jena.sparql.path.P_Path1;
import org.apache.jena.sparql.path.P_Path2;
import org.apache.jena.sparql.path.Path;
import org.apache.jena.sparql.path.PathVisitorByType;
import org.apache.jena.sparql.syntax.Element;
import org.apache.jena.sparql.syntax.ElementGroup;
import org.apache.jena.sparql.syntax.ElementPathBlock;
import org.apache.jena.sparql.syntax.ElementVisitorBase;

class HasPredicateVisitor extends ElementVisitorBase {
	protected String predicate;
	protected boolean found = false;	
	
	public HasPredicateVisitor(String predicate) {
		super();
		this.predicate = predicate;
	}

	@Override
	public void visit(ElementGroup el) {

		for (Element e : el.getElements()) {
			if(e instanceof ElementPathBlock) {
				ElementPathBlock epb = (ElementPathBlock)e;
				Iterator<TriplePath> triples = epb.patternElts();						

				while(triples.hasNext()) {
					TriplePath t = triples.next();
					
					Path p = t.getPath();
					// handle cases where the path is null because it is a variable
					if(p != null) {
						HasPredicatePathVisitor v = new HasPredicatePathVisitor(this.predicate);
						p.visit(v);
						if(v.isFound()) {
							this.found = true;
						}
					}
				}							
			}
		}

	}

	public boolean isFound() {
		return found;
	}
	
	
	class HasPredicatePathVisitor extends PathVisitorByType {
		protected String predicate;
		protected boolean found = false;
		
		public HasPredicatePathVisitor(String predicate) {
			super();
			this.predicate = predicate;
		}

		@Override
		public void visitNegPS(P_NegPropSet path) {
			// not implemented			
		}

		@Override
		public void visit0(P_Path0 path) {
			if(path.getNode().getURI().equals(this.predicate)) {
				this.found = true;
			}
		}

		@Override
		public void visit1(P_Path1 path) {
			path.getSubPath().visit(this);	
		}

		@Override
		public void visit2(P_Path2 path) {
			path.getLeft().visit(this);
			path.getRight().visit(this);
		}

		public boolean isFound() {
			return found;
		}

	}
}