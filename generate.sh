VERSION=V41
DATASET=ENTAM
TESTSET=ENTAM
echo $DATASET "->" $TESTSET 
fairseq-generate data-bin/$TESTSET \
 --task translation \
 --path ./checkpoints/$VERSION-$DATASET/checkpoint_best.pt \
 --source-lang en --target-lang ta\
 --batch-size 32 --beam 5 \
 --results-path ./generation_results/$VERSION-$DATASET-ON-$TESTSET/ \
 --tokenizer moses \
 --remove-bpe sentencepiece