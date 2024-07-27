import Foundation

/*
 ObservableObject
 View - ViewModel 간 데이터 바인드 실현을 위한 Object
 */
final class ObservableObject<T> {
    // 초기 bind skip 횟수
    private var skipCount = 0
    
    // bind를 통해 실제 바라보는 객체
    var value: T? { didSet {
            runListener()
        }
    }
    
    // bind 객체 변화 시 구동 로직
    private var listener: ((T?) -> Void)?
    
    init(_ value: T?) {
        self.value = value
    }
    
    // ObservableObject bind , bind 시 listener 구동된다.
    func bind(_ listener: @escaping(T?) -> Void) {
        self.listener = listener
        runListener()
    }
    
    // Skip Count 지정, ChainAble 가능하도록 self return
    @discardableResult
    func skip(_ count: Int) -> ObservableObject<T> {
        self.skipCount = count
        return self
    }
    
    // 내부 로직 skip count가 남았는지 체크
    private func checkSkip() -> Bool {
        if skipCount == 0 {
            return false
        } else {
            skipCount -= 1
            return true
        }
    }
    
    // 내부 로직 등록된 listener 실행
    private func runListener() {
        if(checkSkip() == false) {
            guard let listener = listener else { return }
            listener(value)
        }
    }
}
