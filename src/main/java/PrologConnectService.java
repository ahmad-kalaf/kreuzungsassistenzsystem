//package meinprojekt;

import java.io.*;
import org.projog.api.Projog;
import org.projog.api.QueryResult;
import org.projog.core.ProjogException;

public class PrologConnectService {
	private Projog projog;

	public PrologConnectService() {
		projog = new Projog();
	}

	public void consultiere(File f) throws ProjogException {
		try {
			Projog projogTemp = new Projog();
			projogTemp.consultFile(f);
			projog = new Projog();
			projog.consultFile(f);
		} catch (ProjogException e) {
			throw e;
		}
	}

	public String fuehrePredikatAus(String kreuzungsart, String a, String b, String c, String d) {
		String predikat = "vorfahrt(" + kreuzungsart + ", [" + a + ", " + b + ", " + c + ", " + d + "], R).";
		QueryResult r3 = projog.executeQuery(predikat);
		r3.next();
		String result = projog.formatTerm(r3.getTerm("R"));
		char A = result.charAt(1);
		char B = result.charAt(3);
		char C = result.charAt(5);
		char D = result.charAt(7);
		return "[" + A + ", " + B + ", " + C + ", " + D + "]";
	}
}
