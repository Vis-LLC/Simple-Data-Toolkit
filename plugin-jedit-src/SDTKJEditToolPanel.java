/*
    Copyright (C) 2022 Vis LLC - All Rights Reserved

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

/*
    Simple Data Toolkit
    JEdit Plugin
*/

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.AbstractButton;
import javax.swing.Box;
import javax.swing.BoxLayout;
import javax.swing.JLabel;
import javax.swing.JPanel;

import org.gjt.sp.jedit.GUIUtilities;
import org.gjt.sp.jedit.jEdit;
import org.gjt.sp.jedit.gui.RolloverButton;

public class SDTKJEditToolPanel extends JPanel {
	private SDTKJEdit pad;

	private JLabel label;

	public SDTKJEditToolPanel(SDTKJEdit qnpad) {
		setLayout(new BoxLayout(this, BoxLayout.X_AXIS));
		pad = qnpad;

		Box labelBox = new Box(BoxLayout.Y_AXIS);
		labelBox.add(Box.createGlue());

		label = new JLabel(pad.getFilename());
		label.setVisible(jEdit.getProperty(
				SDTKJEditPlugin.OPTION_PREFIX + "show-filepath").equals(
				"true"));

		labelBox.add(label);
		labelBox.add(Box.createGlue());

		add(labelBox);

		add(Box.createGlue());

		add(makeCustomButton("SDTKJEdit.csv-to-tsv", new ActionListener() {
			public void actionPerformed(ActionEvent evt) {
				//SDTKJEditToolPanel.this.pad.chooseFile();
			}
		}));
		add(makeCustomButton("SDTKJEdit.tsv-to-csv", new ActionListener() {
			public void actionPerformed(ActionEvent evt) {
				//SDTKJEditToolPanel.this.pad.saveFile();
			}
		}));
		add(makeCustomButton("SDTKJEdit.copy-to-buffer",
				new ActionListener() {
					public void actionPerformed(ActionEvent evt) {
						//SDTKJEditToolPanel.this.pad.copyToBuffer();
					}
				}));
	}

	void propertiesChanged() {
		label.setText(pad.getFilename());
		label.setVisible(jEdit.getProperty(
				SDTKJEditPlugin.OPTION_PREFIX + "show-filepath").equals(
				"true"));
	}

	private AbstractButton makeCustomButton(String name, ActionListener listener) {
		String toolTip = jEdit.getProperty(name.concat(".label"));
		AbstractButton b = new RolloverButton(GUIUtilities.loadIcon(jEdit
				.getProperty(name + ".icon")));
		if (listener != null) {
			b.addActionListener(listener);
			b.setEnabled(true);
		} else {
			b.setEnabled(false);
		}
		b.setToolTipText(toolTip);
		return b;
	}

}
