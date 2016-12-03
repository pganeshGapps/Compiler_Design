%{                     /* C-Declarations */
#include<stdio.h>
#include<stdlib.h>
int i;
struct node{char *data;char *type;struct node *next;int count;};   /* Definition of Linked List */
struct node *head;
struct node *createNode(char *value,char *type);

void function_inst(char *value,char *type);
char k[]="keyword";
char id[]="identifier";
char c[]="constant";
char s[]="stringConstant";


FILE *fp;
FILE *fp1;
FILE *fp2;
FILE *fp3;

%}


/* Translation Rules With Regular Expressions */

comment "//".*

whitespace [ ]

/* Uppercase (uc) and Lowercase (lc) Letters */
uc [A-Z]
lc [a-z]
letter {uc}|{lc}
ascii  [^.\"\n]

digit  [0-9]
hex   ("0X"|"0x")(({digit}|[A-F])+(u|l)(l))
octdigit [0-7]
oct    "0"{octdigit}+  

variable (({lc}|{uc}|"_"))({lc}|{digit})* 

integer     ({digit}|{hex}|{oct})+
text      \"(({ascii})*|({ascii})*(".")({ascii})*)\"


keyword     auto|break|case|char|const|continue|default|do|double|else|enum|extern|float|for|goto|if|int|long|register|return|short|signed|sizeof|static|struct|switch|typedef|union|unsigned|void|volatile|while


/* Functions Definition of Patterns*/
%%
{whitespace} {}
{comment}  {} 
{keyword}  {function_inst(yytext,"keyword");}
{variable} {function_inst(yytext,"identifier");}
{integer}  {function_inst(yytext,"constant");}
{text}     {function_inst(yytext,"stringConstant");}

%%


int main()
{

   fp=fopen("/opt/cc/Documents/CD_lab1/keywords.txt","w");     /* Keywords file */
   fp1=fopen("/opt/cc/Documents/CD_lab1/identifiers.txt","w"); /* Identifiers file */
   fp2=fopen("/opt/cc/Documents/CD_lab1/NumericConstants.txt","w");   /* Num Constants file */
   fp3=fopen("/opt/cc/Documents/CD_lab1/StringConstants.txt","w");   /* String Constants file */

   yylex();


  printf("----Keywords Written In File\n");
  struct node *head2=head; /*Start pointer assign into the head2 pointer*/
  while(head2!=NULL)
   {
     if(strcmp(head2->type,k)==0)
      {
         fprintf(fp,"Keyword : %s ==> %d times\n",head2->data,head2->count);
      }
      head2=head2->next;
   }


  printf("\n----Identifiers Written In File\n");
  struct node *head1=head;
  while(head1!=NULL)
   {
    if(strcmp(head1->type,id)==0)
     {
       fprintf(fp1,"Identifier : %s ==> %d times\n",head1->data,head1->count);
     }
    head1=head1->next;
   }


 printf("\n----Numeric Constants Written In File\n");//Numeric
 head1=head;
 while(head1!=NULL)
  {
    if(strcmp(head1->type,c)==0)
     {
       fprintf(fp2,"Constant : %s ==> %d times\n",head1->data,head1->count);
     }
    head1=head1->next;
  }

 printf("\n----String Constants Written In File\n");//Numeric
 head1=head;
 while(head1!=NULL)
  {
    if(strcmp(head1->type,s)==0)
     {
       fprintf(fp3,"String Constant : %s ==> %d times\n",head1->data,head1->count);
     }
    head1=head1->next;
  }
 
     /* Files are Closed */
     fclose(fp);
     fclose(fp1);
     fclose(fp2);
     fclose(fp3);
     return 0;
}


int yywrap()
{
   return 1;
}


void function_inst(char *value,char *type)
{
  struct node *temp=head;
  while(temp!=NULL)
   {
     if(strcmp(temp->data,value)==0 && strcmp(temp->type,type)==0)
       {
        temp->count++;
        return;
       }
      temp=temp->next;
    }

    struct node *new=createNode(value,type);
    new->count=1;
    new->next=head;
    head=new;
}


/* Node Creations */
struct node *createNode(char *value,char *type)
{
      struct node *new=(struct node*)malloc(sizeof(struct node));
      new->data = (char*)malloc(strlen(value)*sizeof(char)*2);
      new->type = (char*)malloc(strlen(type)*sizeof(char)*2);
      strcpy(new->data,value);
      strcpy(new->type,type);
      return new;
}
