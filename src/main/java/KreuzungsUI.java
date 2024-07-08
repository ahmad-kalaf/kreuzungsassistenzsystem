//package meinprojekt;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.Font;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import javax.swing.BorderFactory;
import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.event.PopupMenuEvent;
import javax.swing.event.PopupMenuListener;
import javax.swing.filechooser.FileNameExtensionFilter;
import org.projog.core.ProjogException;

public class KreuzungsUI {
	private JFrame frame;
	private JPanel panel;
	private JLabel label;
	private String A, B, C, D;
	private PrologConnectService prologConnection;
	private String ergebnis;
	private String kreuzungsart;
	private String resA, resB, resC, resD;
	JLabel labA, labB, labC, labD;
	private boolean konsultiert;
	private Color LABELCOLOR;

	public KreuzungsUI() {
		LABELCOLOR = Color.RED;
		konsultiert = false;
		A = "kein";
		B = "kein";
		C = "kein";
		D = "kein";
		resA = "0";
		resB = "0";
		resC = "0";
		resD = "0";
		ergebnis = "";
		kreuzungsart = "ohne";
		prologConnection = new PrologConnectService();

		frame = new JFrame();
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.setMinimumSize(new Dimension(500, 500));
		frame.setLocationRelativeTo(null);

		panel = new JPanel();
		panel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));
		panel.setLayout(new GridLayout(2, 1, 0, 100));

		JPanel menuPanel = new JPanel();
		// Platzhalter
		JPanel spacer1 = new JPanel();
		spacer1.setPreferredSize(new Dimension(120, 40));
		spacer1.setVisible(false);
		JPanel spacer2 = new JPanel();
		spacer2.setPreferredSize(new Dimension(120, 40));
		spacer2.setVisible(false);
		JPanel spacer3 = new JPanel();
		spacer3.setPreferredSize(new Dimension(120, 40));
		spacer3.setVisible(false);
		JPanel spacer4 = new JPanel();
		spacer4.setPreferredSize(new Dimension(120, 40));
		spacer4.setVisible(false);
		JPanel spacer5 = new JPanel();
		spacer5.setPreferredSize(new Dimension(120, 40));
		spacer5.setVisible(false);

		menuPanel.setLayout(new GridLayout(3, 3, 50, 50));
		String[] richtungswuensche = { "kein", "rechts", "geradeaus", "links" };
		JComboBox<String> menuA = new JComboBox<String>(richtungswuensche);
		menuA.setPreferredSize(new Dimension(120, 40));
		menuA.setFocusable(false);
		menuA.addActionListener(arg -> {
			setA((String) menuA.getSelectedItem());
			reagiereAufAenderung();
		});

		JPanel panA = new JPanel();
		panA.setLayout(new BoxLayout(panA, BoxLayout.X_AXIS));
		labA = new JLabel(resA + "  ");
		labA.setForeground(LABELCOLOR);
		labA.setFont(new Font("SansSerif", Font.PLAIN, 10));
		panA.add(labA);
		panA.add(menuA);

		JComboBox<String> menuB = new JComboBox<String>(richtungswuensche);
		menuB.setPreferredSize(new Dimension(120, 40));
		menuB.setFocusable(false);
		menuB.addActionListener(arg -> {
			setB((String) menuB.getSelectedItem());
			reagiereAufAenderung();
		});

		JPanel panB = new JPanel();
		panB.setLayout(new BoxLayout(panB, BoxLayout.X_AXIS));
		labB = new JLabel(resB + "  ");
		labB.setForeground(LABELCOLOR);
		labB.setFont(new Font("SansSerif", Font.PLAIN, 10));
		panB.add(labB);
		panB.add(menuB);

		JComboBox<String> menuC = new JComboBox<String>(richtungswuensche);
		menuC.setPreferredSize(new Dimension(120, 40));
		menuC.setFocusable(false);
		menuC.addActionListener(arg -> {
			setC((String) menuC.getSelectedItem());
			reagiereAufAenderung();
		});

		JPanel panC = new JPanel();
		panC.setLayout(new BoxLayout(panC, BoxLayout.X_AXIS));
		labC = new JLabel("  " + resC);
		labC.setForeground(LABELCOLOR);
		labC.setFont(new Font("SansSerif", Font.PLAIN, 10));
		panC.add(menuC);
		panC.add(labC);

		JComboBox<String> menuD = new JComboBox<String>(richtungswuensche);
		menuD.setPreferredSize(new Dimension(120, 40));
		menuD.setFocusable(false);
		menuD.addActionListener(arg -> {
			setD((String) menuD.getSelectedItem());
			reagiereAufAenderung();
		});
		menuD.addPopupMenuListener(new PopupMenuListener() {

			@Override
			public void popupMenuWillBecomeVisible(PopupMenuEvent arg0) {
				reagiereAufAenderung();
			}

			@Override
			public void popupMenuWillBecomeInvisible(PopupMenuEvent arg0) {
				// TODO Auto-generated method stub

			}

			@Override
			public void popupMenuCanceled(PopupMenuEvent arg0) {
				// TODO Auto-generated method stub

			}
		});

		JPanel panD = new JPanel();
		panD.setLayout(new BoxLayout(panD, BoxLayout.X_AXIS));
		labD = new JLabel(resD + "  ");
		labD.setForeground(LABELCOLOR);
		labD.setFont(new Font("SansSerif", Font.PLAIN, 10));
		panD.add(labD);
		panD.add(menuD);

		menuPanel.add(spacer1);
		menuPanel.add(panB);
		menuPanel.add(spacer2);
		menuPanel.add(panA);
		menuPanel.add(spacer3);
		menuPanel.add(panC);
		menuPanel.add(spacer4);
		menuPanel.add(panD);
		menuPanel.add(spacer5);

		String[] kreuzungsarten = { "ohne", "mitOU", "mitOR" };
		JComboBox<String> menuKreuzungsart = new JComboBox<String>(kreuzungsarten);
		menuKreuzungsart.setPreferredSize(new Dimension(120, 40));
		menuKreuzungsart.setFocusable(false);
		menuKreuzungsart.addActionListener(arg -> {
			setKreuzungsart((String) menuKreuzungsart.getSelectedItem());
			reagiereAufAenderung();
		});

		JPanel textPanel = new JPanel();
		textPanel.setLayout(new FlowLayout());
		label = new JLabel("Es wurde noch keine Datei konsultiert");

		JButton chooseFile = new JButton("Neue Datei Konsultieren");
		chooseFile.setFocusable(false);
		chooseFile.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				JFileChooser fileChooser = new JFileChooser();
				FileNameExtensionFilter filter = new FileNameExtensionFilter("Prolog-Dateien", "pl");
				fileChooser.setFileFilter(filter);

				int returnValue = fileChooser.showOpenDialog(frame);
				if (returnValue == JFileChooser.APPROVE_OPTION) {
					File selectedFile = fileChooser.getSelectedFile();

					// Verwende try-with-resources für den File-Chooser
					try (FileInputStream fileInputStream = new FileInputStream(selectedFile)) {
						prologConnection.consultiere(selectedFile);
						konsultiert = true;
						reagiereAufAenderung();
						JOptionPane.showMessageDialog(chooseFile, "Die Datei wurde erfolgreich konsultiert");
					} catch (IOException ioException) {
						JOptionPane.showMessageDialog(frame, "Fehler beim Öffnen oder Lesen der Datei", "Fehler",
								JOptionPane.ERROR_MESSAGE);
						konsultiert = false;
					} catch (ProjogException projogException) {
						JOptionPane.showMessageDialog(frame, "Fehler beim Konsultieren der Datei", "Fehler",
								JOptionPane.ERROR_MESSAGE);
						konsultiert = false;
					}
				}
			}
		});

		JPanel spacer6 = new JPanel();
		spacer6.setPreferredSize(new Dimension(20, 10));
		JPanel spacer7 = new JPanel();
		spacer7.setPreferredSize(new Dimension(20, 10));

		textPanel.add(menuKreuzungsart);
		textPanel.add(spacer6);
		textPanel.add(spacer7);
		textPanel.add(label);
		textPanel.add(chooseFile);

		panel.add(menuPanel);
		panel.add(textPanel);

		frame.add(panel);
		frame.setVisible(true);
	}

	private void reagiereAufAenderung() {
		if (konsultiert) {
			ergebnis = prologConnection.fuehrePredikatAus(getKreuzungsart(), getA(), getB(), getC(), getD());
			label.setText("Reihenfolge = " + ergebnis);
			labA.setText(String.valueOf(ergebnis.charAt(1)) + "  ");
			labB.setText(String.valueOf(ergebnis.charAt(4)) + "  ");
			labC.setText("  " + String.valueOf(ergebnis.charAt(7)));
			labD.setText(String.valueOf(ergebnis.charAt(10)) + "  ");
		} else {
			JOptionPane.showMessageDialog(frame, "Bitte konsultiere zuerst eine Datei");
		}
	}

	public String getKreuzungsart() {
		return kreuzungsart;
	}

	public void setKreuzungsart(String kreuzungsart) {
		this.kreuzungsart = kreuzungsart;
	}

	public String getA() {
		return A;
	}

	public void setA(String a) {
		A = a;
	}

	public String getB() {
		return B;
	}

	public void setB(String b) {
		B = b;
	}

	public String getC() {
		return C;
	}

	public void setC(String c) {
		C = c;
	}

	public String getD() {
		return D;
	}

	public void setD(String d) {
		D = d;
	}
}
