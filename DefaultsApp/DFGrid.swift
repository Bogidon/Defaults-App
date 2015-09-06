//
//  DFGrid.swift
//  
//
//  Created by Bogdan Vitoc on 9/5/15.
//
//

import UIKit
import PureLayout

class DFGrid: UIView {
    private var columns : Int = 0
    private var rows : Int = 0
    private var cells : [UIView] = []
    private var maximumColumnSize : CGFloat = 200.0
    private var cells2dArray : [[UIView]] = []
    
    override func layoutSubviews() {
        columns = Int(round(bounds.size.width / maximumColumnSize))
        configure(cells)
    }
    
    func configure(cells: [UIView]) {
        // Remove old data
        for cell in self.cells {
            cell.removeFromSuperview();
        }
        
        self.cells = cells;
        
        if columns <= 0 || cells.count == 0 {
            return
        }
    
        rows = Int(Float(cells.count) / Float(columns))
        
        // Prepare cells for layout
        for cell in self.cells {
            cell.setTranslatesAutoresizingMaskIntoConstraints(false)
            self.addSubview(cell)
        }
        
        var i : Int = 1
        for cell in self.cells {
            
            var row = Int(floor(Float(i) / Float(columns))) - 1
            var column = i % columns
        
            var superviewEdges = [ALEdge]()
            
            if row == 0 {
                superviewEdges.append(ALEdge.Top)
            }
            if row == rows {
                superviewEdges.append(ALEdge.Bottom)
            }
            if column == 0 {
                superviewEdges.append(ALEdge.Leading)
            }
            if column == columns {
                superviewEdges.append(ALEdge.Trailing)
            }
            
            // Constraints to superview
            for edge in superviewEdges {
                cell.autoPinEdgeToSuperviewEdge(edge, withInset: 0.0);
            }
            
            // Constraints to other cells
            var allEdges : [ALEdge] = [ALEdge.Top, ALEdge.Bottom, ALEdge.Left, ALEdge.Right]
            var excludedEdges = allEdges.filter({!contains(superviewEdges, $0)})
            
            for edge in excludedEdges {
                switch edge {
                case ALEdge.Leading:
                    cell.autoPinEdge(
                        ALEdge.Leading,
                        toEdge: ALEdge.Trailing,
                        ofView: self.cells[getIndex(row, column: column-1)])
                case ALEdge.Trailing:
                    cell.autoPinEdge(
                        ALEdge.Trailing,
                        toEdge: ALEdge.Leading,
                        ofView: self.cells[getIndex(row, column: column+1)])
                case ALEdge.Top:
                    cell.autoPinEdge(
                        ALEdge.Top,
                        toEdge: ALEdge.Bottom,
                        ofView: self.cells[getIndex(row-1, column: column)])
                case ALEdge.Bottom:
                    cell.autoPinEdge(
                        ALEdge.Leading,
                        toEdge: ALEdge.Trailing,
                        ofView: self.cells[getIndex(row-1, column: column)])
                default:
                    break
                }
            }
            
            i++
        }
    }
    
    func getIndex(row: Int, column: Int) -> Int {
        return (row * columns) + column + 1
    }
}
