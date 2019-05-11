import Foundation

struct CompressedGene {
    let length : Int
    private let bitVector: CFMutableBitVector //CoreFoundation Mutable Bit Vector
    
    init(original: String) {
        length = original.count
        //allocator and a capactity (we need 2 bits for every nucleotide)
        bitVector = CFBitVectorCreateMutable(kCFAllocatorDefault, length * 2)
        //setting the bit vector size
        CFBitVectorSetCount(bitVector, length * 2)
        compress(gene: original)
    }
    
    func compress(gene: String) -> CFMutableBitVector{
        for (index, nucleotide) in gene.uppercased().enumerated() {
            let nStart = index * 2 //start of each new nucletoide
            switch nucleotide {
            case "A": //00
                CFBitVectorSetBitAtIndex(bitVector, nStart, 0)
                CFBitVectorSetBitAtIndex(bitVector, nStart + 1, 0)
            case "C": //01
                CFBitVectorSetBitAtIndex(bitVector, nStart, 0)
                CFBitVectorSetBitAtIndex(bitVector, nStart + 1, 1)
            case "G": //10
                CFBitVectorSetBitAtIndex(bitVector, nStart, 1)
                CFBitVectorSetBitAtIndex(bitVector, nStart + 1, 0)
            case "T": //11
                CFBitVectorSetBitAtIndex(bitVector, nStart, 1)
                CFBitVectorSetBitAtIndex(bitVector, nStart + 1, 1)
            default:
                print("Unexpected character \(nucleotide) at \(index)")
            }
        }
        return bitVector
    }
    
    func decompress() -> String {
        var gene: String = ""
        for index in 0..<length {
            let nStart = index * 2 //Start of each nucleotide
            let firstBit = CFBitVectorGetBitAtIndex(bitVector, nStart)
            let secondBit = CFBitVectorGetBitAtIndex(bitVector, nStart + 1)
            switch (firstBit, secondBit) {
            case (0,0):
                gene += "A"
            case (0,1):
                gene += "C"
            case (1,0):
                gene += "G"
            case (1,1):
                gene += "T"
            default:
                break
            }
        }
        return gene
    }
}
print(CompressedGene(original: "ATGAATGCC").decompress())
