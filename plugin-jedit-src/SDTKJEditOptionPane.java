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

import java.awt.BorderLayout;
import java.awt.Font;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JFileChooser;
import javax.swing.JPanel;
import javax.swing.JTextField;

import org.gjt.sp.jedit.AbstractOptionPane;
import org.gjt.sp.jedit.GUIUtilities;
import org.gjt.sp.jedit.jEdit;
import org.gjt.sp.jedit.gui.FontSelector;

public class SDTKJEditOptionPane extends AbstractOptionPane implements
		ActionListener {
	private JCheckBox showPath;

	private JTextField pathName;

	private FontSelector font;

	public SDTKJEditOptionPane() {
		super(SDTKJEditPlugin.NAME);
	}

	public void _init() {
		showPath = new JCheckBox(jEdit
				.getProperty(SDTKJEditPlugin.OPTION_PREFIX
						+ "show-filepath.title"), jEdit.getProperty(
				SDTKJEditPlugin.OPTION_PREFIX + "show-filepath").equals(
				"true"));
		addComponent(showPath);

		pathName = new JTextField(jEdit
				.getProperty(SDTKJEditPlugin.OPTION_PREFIX + "filepath"));
		JButton pickPath = new JButton(jEdit
				.getProperty(SDTKJEditPlugin.OPTION_PREFIX + "choose-file"));
		pickPath.addActionListener(this);

		JPanel pathPanel = new JPanel(new BorderLayout(0, 0));
		pathPanel.add(pathName, BorderLayout.CENTER);
		pathPanel.add(pickPath, BorderLayout.EAST);

		addComponent(jEdit.getProperty(SDTKJEditPlugin.OPTION_PREFIX
				+ "file"), pathPanel);

		font = new FontSelector(makeFont());
		addComponent(jEdit.getProperty(SDTKJEditPlugin.OPTION_PREFIX
				+ "choose-font"), font);
	}

	public void _save() {
		jEdit.setProperty(SDTKJEditPlugin.OPTION_PREFIX + "filepath",
				pathName.getText());
		Font _font = font.getFont();
		jEdit.setProperty(SDTKJEditPlugin.OPTION_PREFIX + "font", _font
				.getFamily());
		jEdit.setProperty(SDTKJEditPlugin.OPTION_PREFIX + "fontsize", String
				.valueOf(_font.getSize()));
		jEdit.setProperty(SDTKJEditPlugin.OPTION_PREFIX + "fontstyle",
				String.valueOf(_font.getStyle()));
		jEdit.setProperty(SDTKJEditPlugin.OPTION_PREFIX + "show-filepath",
				String.valueOf(showPath.isSelected()));
	}

	// end AbstractOptionPane implementation

	// begin ActionListener implementation
	public void actionPerformed(ActionEvent evt) {
		String[] paths = GUIUtilities.showVFSFileDialog(null, null,
				JFileChooser.OPEN_DIALOG, false);
		if (paths != null) {
			pathName.setText(paths[0]);
		}
	}

	// helper method to get Font from plugin properties
	static public Font makeFont() {
		int style, size;
		String family = jEdit.getProperty(SDTKJEditPlugin.OPTION_PREFIX
				+ "font");
		try {
			size = Integer
					.parseInt(jEdit
							.getProperty(SDTKJEditPlugin.OPTION_PREFIX
									+ "fontsize"));
		} catch (NumberFormatException nf) {
			size = 14;
		}
		try {
			style = Integer
					.parseInt(jEdit
							.getProperty(SDTKJEditPlugin.OPTION_PREFIX
									+ "fontstyle"));
		} catch (NumberFormatException nf) {
			style = Font.PLAIN;
		}
		return new Font(family, style, size);
	}

}
