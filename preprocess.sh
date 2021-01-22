DATASET=PIB
fairseq-preprocess --source-lang en --target-lang ta \
    --trainpref intermediate_datasets/BPE/$DATASET/train --validpref intermediate_datasets/BPE/$DATASET/val --testpref intermediate_datasets/BPE/$DATASET/test \
    --destdir ./data-bin/$DATASET \
    --srcdict voc/dict.en.txt \
    --tgtdict voc/dict.ta.txt \
    --workers 20


