//
//  SignCommitmentView.swift
//  nomore
//
//  Created by Aa on 2025-08-27.
//

import SwiftUI

struct SignCommitmentView: View {
    @ObservedObject var manager: OnboardingManager
    
    @State private var signature = Path()
    @State private var currentStroke = Path()
    @State private var showContent = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Navigation bar
            HStack {
                Button(action: {
                    manager.back()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            // Content
            VStack(spacing: 32) {
                // Header
                VStack(spacing: 16) {
                    Text("Sign your commitment")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .opacity(showContent ? 1.0 : 0.0)
                        .offset(y: showContent ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(0.2), value: showContent)
                    
                    Text("Finally, promise yourself that you will never watch porn again.")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white.opacity(0.85))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 32)
                        .opacity(showContent ? 1.0 : 0.0)
                        .offset(y: showContent ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(0.4), value: showContent)
                }
                .padding(.top, 20)
                
                // Drawing canvas
                VStack(spacing: 16) {
                    ZStack {
                        // Canvas background
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(.white)
                            .frame(height: 280)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                        
                        // Drawing area
                        DrawingCanvas(signature: $signature, currentStroke: $currentStroke)
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    }
                    .padding(.horizontal, 24)
                    .opacity(showContent ? 1.0 : 0.0)
                    .offset(y: showContent ? 0 : 30)
                    .animation(.easeOut(duration: 0.6).delay(0.6), value: showContent)
                    
                    // Clear button
                    HStack {
                        Button(action: clearSignature) {
                            Text("Clear")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .opacity(showContent ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.6).delay(0.8), value: showContent)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                }
                
                Spacer(minLength: 20)
                
                // Instructions
                Text("Draw on the open space above")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                    .opacity(showContent ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 0.6).delay(1.0), value: showContent)
                
                Spacer(minLength: 20)
            }
            
            // Finish button
            Button(action: {
                manager.next()
            }) {
                Text("Finish")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Color(red: 0.0, green: 0.48, blue: 0.98), Color(red: 0.0, green: 0.32, blue: 0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
            .opacity(showContent ? 1.0 : 0.0)
            .offset(y: showContent ? 0 : 30)
            .animation(.easeOut(duration: 0.6).delay(1.2), value: showContent)
        }
        .appBackground()
        .onAppear {
            showContent = true
        }
    }
    
    private func clearSignature() {
        signature = Path()
        currentStroke = Path()
    }
}

struct DrawingCanvas: UIViewRepresentable {
    @Binding var signature: Path
    @Binding var currentStroke: Path
    
    func makeUIView(context: Context) -> DrawingView {
        let view = DrawingView()
        view.onDrawingChanged = { path in
            DispatchQueue.main.async {
                self.signature = path
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: DrawingView, context: Context) {
        if signature.isEmpty {
            uiView.clearDrawing()
        }
    }
}

class DrawingView: UIView {
    var onDrawingChanged: ((Path) -> Void)?
    private var path = UIBezierPath()
    private var allPaths: [UIBezierPath] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isMultipleTouchEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.black.setStroke()
        
        for path in allPaths {
            path.lineWidth = 3.0
            path.lineCapStyle = .round
            path.lineJoinStyle = .round
            path.stroke()
        }
        
        path.lineWidth = 3.0
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        path.stroke()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: self)
        path = UIBezierPath()
        path.move(to: point)
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: self)
        path.addLine(to: point)
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        allPaths.append(path)
        updateSwiftUIPath()
        setNeedsDisplay()
    }
    
    private func updateSwiftUIPath() {
        var swiftUIPath = Path()
        
        for bezierPath in allPaths {
            let cgPath = bezierPath.cgPath
            swiftUIPath.addPath(Path(cgPath))
        }
        
        onDrawingChanged?(swiftUIPath)
    }
    
    func clearDrawing() {
        allPaths.removeAll()
        path = UIBezierPath()
        setNeedsDisplay()
    }
}

#Preview {
    let manager = OnboardingManager()
    return SignCommitmentView(manager: manager)
}
